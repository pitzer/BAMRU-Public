['abstract_model/attributable',
  'abstract_model/interface_attributes',
  'abstract_model/dirty',
  'abstract_model/relatable',
  'abstract_model/validatable'].each do |lib|
  require File.expand_path(lib, File.dirname(__FILE__))
end

module VirtualBox
  # AbstractModel is the base class used for most of virtualbox's classes.
  # It provides convenient ActiveRecord-style model behavior to subclasses.
  #
  # @abstract
  class AbstractModel
    include Logger

    include Attributable
    include InterfaceAttributes
    include Dirty
    include Relatable
    include Validatable

    class << self
      # Returns whether or not the class should be reloaded.
      #
      # @return [Boolean]
      def reload?
        !!@_reload
      end

      def reload!
        @_reload = true
      end

      def reloaded!
        @_reload = false
      end

      # Default errors for relationship implementation, since this is
      # a pretty stable method.
      def errors_for_relationship(caller, data)
        return data.errors if data.respond_to?(:errors)
        nil
      end
    end

    # Signals to the class that it should be reloaded. This simply toggles
    # a boolean value to true. It is up to the subclass to implement functionality
    # around it. See {reload?}
    def reload!
      self.class.reload!
    end

    # Returns a boolean denoting if the record is new or existing. This
    # method is provided for subclasses to use to differentiate between
    # creating a new object or saving an existing one. An example of this
    # is {HardDrive#save} which will create a new hard drive if it didn't
    # previously exist, or save an old one if it did exist.
    def new_record?
      new_record! if @new_record.nil?
      @new_record
    end

    # Explicitly resets the model to a new record. If you're using this
    # method outside of virtualbox library core, you should really be
    # asking yourself "why?"
    def new_record!
      @new_record = true
    end

    # Explicitly sets the model to not be a new record. If you're using
    # this method outside of virtualbox library core, you should really
    # be asking yourself "why?"
    def existing_record!
      @new_record = false
    end

    # Returns the errors for a model.
    def errors
      self.class.relationships.inject(super) do |acc, data|
        name, options = data

        if options && options[:klass].respond_to?(:errors_for_relationship)
          errors = options[:klass].errors_for_relationship(self, relationship_data[name])
          acc.merge!(name => errors) if errors && !errors.empty?
        end

        acc
      end
    end

    # Validates the model and relationships.
    def validate(*args)
      # First clear all previous errors
      clear_errors

      # Then do the validations
      failed = false
      self.class.relationships.each do |name, options|
        next unless options && options[:klass].respond_to?(:validate_relationship)
        failed = true if !options[:klass].validate_relationship(self, relationship_data[name], *args)
      end

      return !failed
    end

    # Saves the model attributes and relationships.
    #
    # The method can be passed any arbitrary arguments, which are
    # implementation specific (see {VM#save}, which does this).
    def save(*args)
      # Go through changed attributes and call save_attribute for
      # those only
      changes.each do |key, values|
        save_attribute(key, values[1], *args)
      end

      # Go through and only save the loaded relationships, since
      # only those would be modified.
      self.class.relationships.each do |name, options|
        save_relationship(name, *args)
      end

      # No longer a new record
      @new_record = false

      true
    end

    # Saves the model and raises an {Exceptions::ValidationFailedException}
    # if the model is invalid, instead of returning false.
    def save!(*args)
      raise Exceptions::ValidationFailedException.new(errors.inspect) if !save(*args)
      true
    end

    # Saves a single attribute of the model. This method on the abstract
    # model does nothing on its own, and is expected to be overridden
    # by any subclasses.
    #
    # This method clears the dirty status of the attribute.
    def save_attribute(key, value, *args)
      clear_dirty!(key)
    end

    # Saves only changed interface attributes.
    def save_changed_interface_attributes(interface)
      changes.each do |key, values|
        save_interface_attribute(key, interface)
      end
    end

    # Overrides {InterfaceAttributes.save_interface_attribute} to clear the
    # dirty state of the attribute.
    def save_interface_attribute(key, interface)
      super
      clear_dirty!(key)
    end

    # Overriding {Attributable#lazy_attribute?} to always return false for
    # new records, since new records shouldn't load lazy data.
    def lazy_attribute?(*args)
      return false if new_record?
      super
    end

    # Overriding {Relatable#lazy_relationship?} to always return false for
    # new records, since new records shouldn't load lazy data.
    def lazy_relationship?(*args)
      return false if new_record?
      super
    end

    # Sets the initial attributes from a hash. This method is meant to be used
    # once to initially setup the attributes. It is **not a mass-assignment**
    # method for updating attributes.
    #
    # This method does **not** affect dirtiness, but also does not clear it.
    # This means that if you call populate_attributes, the same attributes
    # that were dirty before the call will be dirty after the call (but no
    # more and no less). This distinction is important because most subclasses
    # of AbstractModel only save changed attributes, and ignore unchanged
    # attributes. Attempting to change attributes through this method will
    # cause them to not be saved, which is surely unexpected behaviour for
    # most users.
    #
    # Calling this method will also cause the model to assume that it is not
    # a new record (see {#new_record?}).
    def populate_attributes(attribs, opts={})
      ignore_dirty do
        super(attribs)

        populate_relationships(attribs) unless opts[:ignore_relationships]
      end

      # No longer a new record
      existing_record!
    end

    # Loads and populates the relationships with the given data. This method
    # is meant to be used once to initially setup the relatoinships.
    #
    # This methods does **not** affect dirtiness, but also does not clear it.
    #
    # Calling this method will also cuase the model to assume that it is not
    # a new record (see {#new_record?})
    def populate_relationships(data)
      existing_record!
      ignore_dirty { super }
    end

    # Populates a single relationship with the given data.
    def populate_relationship(name, data)
      existing_record!
      ignore_dirty { super }
    end

    # Overwrites {Attributable#write_attribute} to set the dirty state of
    # the written attribute. See {Dirty#set_dirty!} as well.
    def write_attribute(name, value)
      set_dirty!(name, read_attribute(name), value) unless lazy_attribute?(name) && !loaded_attribute?(name)
      super
    end

    # Overwrites {Relatable#set_relationship} to set the dirty state of the
    # relationship. See {Dirty#set_dirty!} as well.
    def set_relationship(key, value)
      existing = relationship_data[key]
      new_value = super
      set_dirty!(key, existing, new_value)
    end

    # Destroys the model. The exact behaviour of this method is expected to be
    # defined on the subclasses. This method on AbstractModel simply
    # propagates the destroy to the dependent relationships. For more information
    # on relationships, see {Relatable}.
    def destroy(*args)
      # Destroy dependent relationships
      self.class.relationships.each do |name, options|
        destroy_relationship(name, *args) if options[:dependent] == :destroy
      end
    end

    # Gets the root machine of an AbstractModel by traversing a
    # `parent` attribute until it reaches a type of {VM}.
    #
    # @return [VM]
    def parent_machine
      current = parent
      current = current.parent while current && !current.is_a?(VM)
      current
    end

    # Creates a human-readable format for this model. This method overrides the
    # default `#<class>` syntax since this doesn't work well for AbstractModels.
    # Instead, it abbreviates it, instead showing all the attributes and their
    # values, and `...` for relationships. For attributes which are themselves
    # AbstractModels, it shows the class name to avoid extremely verbose inspections
    # and infinite loops.
    def inspect
      values = []

      self.class.attributes.each do |name, options|
        value = read_attribute(name)
        value = if value.is_a?(AbstractModel) || value.is_a?(COM::AbstractInterface) || value.is_a?(Proxies::Collection)
          "#<#{value.class.name}>"
        else
          value.inspect
        end

        values.push("#{name.inspect}=#{value}")
      end

      self.class.relationships.each do |name, options|
        values.push("#{name.inspect}=...")
      end

      "#<#{self.class} #{values.sort.join(", ")}>".strip
    end
  end
end
