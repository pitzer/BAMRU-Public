require 'virtualbox/abstract_model/version_matcher'

module VirtualBox
  class AbstractModel
    # Provides simple relationship features to any class. These relationships
    # can be anything, since this module makes no assumptions and doesn't
    # differentiate between "has many" or "belongs to" or any of that.
    #
    # The way it works is simple:
    #
    # 1. Relationships are defined with a relationship name and a
    #    class of the relationship objects.
    # 2. When {#populate_relationships} is called, `populate_relationship` is
    #    called on each relationship class (example: {StorageController.populate_relationship}).
    #    This is expected to return the relationship, which can be any object.
    # 3. When {#save_relationships} is called, `save_relationship` is
    #     called on each relationship class, which manages saving its own
    #     relationship.
    # 4. When {#destroy_relationships} is called, `destroy_relationship` is
    #     called on each relationship class, which manages destroying
    #     its own relationship.
    #
    # Be sure to read {ClassMethods} for complete documentation of methods.
    #
    # # Defining Relationships
    #
    # Every relationship has two mandatory parameters: the name and the class.
    #
    #     relationship :bacons, Bacon
    #
    # In this case, there is a relationship `bacons` which refers to the `Bacon`
    # class.
    #
    # # Accessing Relationships
    #
    # Relatable offers up dynamically generated accessors for every relationship
    # which simply returns the relationship data.
    #
    #     relationship :bacons, Bacon
    #
    #     # Accessing through an instance "instance"
    #     instance.bacons # => whatever Bacon.populate_relationship created
    #
    # # Settable Relationships
    #
    # It is often convenient that relationships become "settable." That is,
    # for a relationship `foos`, there would exist a `foos=` method. This is
    # possible by implementing the `set_relationship` method on the relationship
    # class. Consider the following relationship:
    #
    #     relationship :foos, Foo
    #
    # If `Foo` has the `set_relationship` method, then it will be called by
    # `foos=`. It is expected to return the new value for the relationship. To
    # facilitate this need, the `set_relationship` method is given three
    # parameters: caller, old value, and new value. An example implementation,
    # albeit a silly one, is below:
    #
    #     class Foo
    #       def self.set_relationship(caller, old_value, new_value)
    #         return "Changed to: #{new_value}"
    #       end
    #     end
    #
    # In this case, the following behavior would occur:
    #
    #     instance.foos # => assume "foo"
    #     instance.foos = "bar"
    #     instance.foos # => "Changed to: bar"
    #
    # If the relationship class _does not implement_ the `set_relationship`
    # method, then a {Exceptions::NonSettableRelationshipException} will be raised if
    # a user attempts to set that relationship.
    #
    # # Dependent Relationships
    #
    # By setting `:dependent => :destroy` on relationships, {AbstractModel}
    # will automatically call {#destroy_relationships} when {AbstractModel#destroy}
    # is called.
    #
    # This is not a feature built-in to Relatable but figured it should be
    # mentioned here.
    #
    # # Lazy Relationships
    #
    # Often, relationships are pretty heavy things to load. Data may have to be
    # retrieved, classes instantiated, etc. If a class has many relationships, or
    # many relationships within many relationships, the time and memory required
    # for relationships really begins to add up. To address this issue, _lazy relationships_
    # are available. Lazy relationships defer loading their content until the
    # last possible moment, or rather, when a user requests the data. By specifing
    # the `:lazy => true` option to relationships, relationships will not be loaded
    # immediately. Instead, when they're first requested, `load_relationship` will
    # be called on the model, with the name of the relationship given as a
    # parameter. It is up to this method to call {#populate_relationship} at some
    # point with the data to setup the relationship. An example follows:
    #
    #     class SomeModel
    #       include VirtualBox::AbstractModel::Relatable
    #
    #       relationship :foos, Foo, :lazy => true
    #
    #       def load_relationship(name)
    #         if name == :foos
    #           populate_relationship(name, get_data_for_a_long_time)
    #         end
    #       end
    #     end
    #
    # Using the above class, we can use it like so:
    #
    #     model = SomeModel.new
    #
    #     # This initial load takes awhile as it loads...
    #     model.foos
    #
    #     # Instant! (Just a hash lookup. No load necessary)
    #     model.foos
    #
    # One catch: If a model attempts to {#destroy_relationship destroy} a lazy
    # relationship, it will first load the relationship, since destroy typically
    # depends on some data of the relationship.
    module Relatable
      include VersionMatcher

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Define a relationship. The name and class must be specified. This
        # class will be used to call the `populate_relationship,
        # `save_relationship`, etc. methods.
        #
        # @param [Symbol] name Relationship name. This will also be used for
        #   the dynamically generated accessor.
        # @param [Class] klass Class of the relationship.
        # @option options [Symbol] :dependent (nil) - If set to `:destroy`
        #   {AbstractModel#destroy} will propagate through to relationships.
        def relationship(name, klass, options = {})
          name = name.to_sym

          relationships << [name, { :klass => klass }.merge(options)]

          # Define the method to read the relationship
          define_method(name) { read_relationship(name) }

          # Define the method to set the relationship
          define_method("#{name}=") { |*args| set_relationship(name, *args) }
        end

        # Returns a hash of all the relationships.
        #
        # @return [Hash]
        def relationships_hash
          Hash[*relationships.flatten]
        end

        # Returns an array of the relationships in order of being added.
        #
        # @return [Array]
        def relationships
          @relationships ||= []
        end

        # Returns a boolean of whether a relationship exists.
        #
        # @return [Boolean]
        def has_relationship?(name)
          !!relationships.detect { |r| r[0] == name }
        end

        # Used to propagate relationships to subclasses. This method makes sure that
        # subclasses of a class with {Relatable} included will inherit the
        # relationships as well, which would be the expected behaviour.
        def inherited(subclass)
          super rescue NoMethodError

          relationships.each do |name, options|
            subclass.relationship(name, nil, options)
          end
        end
      end

      # Reads a relationship. This is equivalent to {Attributable#read_attribute},
      # but for relationships.
      def read_relationship(name)
        options = self.class.relationships_hash[name.to_sym]
        assert_version_match(options[:version], VirtualBox.version) if options[:version]

        if lazy_relationship?(name) && !loaded_relationship?(name)
          load_relationship(name)
        end

        relationship_data[name.to_sym]
      end

      # Saves the model, calls save_relationship on all relations. It is up to
      # the relation to determine whether anything changed, etc. Simply
      # calls `save_relationship` on each relationship class passing in the
      # following parameters:
      #
      # * **caller** - The class which is calling save
      # * **data** - The data associated with the relationship
      #
      # In addition to those two args, any arbitrary args may be tacked on to the
      # end and they'll be pushed through to the `save_relationship` method.
      def save_relationships(*args)
        # Can't use `all?` here since it short circuits
        results = self.class.relationships.collect do |data|
          name, options = data
          !!save_relationship(name, *args)
        end

        !results.include?(false)
      end

      # Saves a single relationship. It is up to the relationship class to
      # determine whether anything changed and how saving is implemented. Simply
      # calls `save_relationship` on the relationship class.
      def save_relationship(name, *args)
        options = self.class.relationships_hash[name]
        return if lazy_relationship?(name) && !loaded_relationship?(name)
        return if options[:version] && !version_match?(options[:version], VirtualBox.version)
        return unless relationship_class(name).respond_to?(:save_relationship)
        relationship_class(name).save_relationship(self, relationship_data[name], *args)
      end

      # The equivalent to {Attributable#populate_attributes}, but with
      # relationships.
      def populate_relationships(data)
        self.class.relationships.each do |name, options|
          populate_relationship(name, data) unless lazy_relationship?(name)
        end
      end

      # Populate a single relationship.
      def populate_relationship(name, data)
        options = self.class.relationships_hash[name]
        return unless relationship_class(name).respond_to?(:populate_relationship)
        return if options[:version] && !version_match?(options[:version], VirtualBox.version)
        relationship_data[name] = relationship_class(name).populate_relationship(self, data)
      end

      # Calls `destroy_relationship` on each of the relationships. Any
      # arbitrary args may be added and they will be forarded to the
      # relationship's `destroy_relationship` method.
      def destroy_relationships(*args)
        self.class.relationships.each do |name, options|
          destroy_relationship(name, *args)
        end
      end

      # Destroys only a single relationship. Any arbitrary args
      # may be added to the end and they will be pushed through to
      # the class's `destroy_relationship` method.
      #
      # @param [Symbol] name The name of the relationship
      def destroy_relationship(name, *args)
        options = self.class.relationships_hash[name]
        return unless options && relationship_class(name).respond_to?(:destroy_relationship)

        # Read relationship, which forces lazy relationships to load, which is
        # probably necessary for destroying
        read_relationship(name)

        relationship_class(name).destroy_relationship(self, relationship_data[name], *args)
      end

      # Hash to data associated with relationships. You should instead
      # use the accessors created by Relatable.
      #
      # @return [Hash]
      def relationship_data
        @relationship_data ||= {}
      end

      # Returns boolean denoting if a relationship exists.
      #
      # @return [Boolean]
      def has_relationship?(key)
        self.class.has_relationship?(key.to_sym)
      end

      # Returns boolean denoting if a relationship is to be lazy loaded.
      #
      # @return [Boolean]
      def lazy_relationship?(key)
        options = self.class.relationships_hash[key.to_sym]
        !options.nil? && options[:lazy]
      end

      # Returns boolean denoting if a relationship has been loaded.
      def loaded_relationship?(key)
        relationship_data.has_key?(key)
      end

      # Returns the class for a given relationship. This method handles converting
      # a string/symbol into the proper class.
      #
      # @return [Class]
      def relationship_class(key)
        options = self.class.relationships_hash[key.to_sym]
        klass = options[:klass]
        klass = Object.module_eval("#{klass}") unless klass.is_a?(Class)
        klass
      end

      # Sets a relationship to the given value. This is not guaranteed to
      # do anything, since "set_relationship" will be called on the class
      # that the relationship is associated with and its expected to return
      # the resulting relationship to set.
      #
      # If the relationship class doesn't respond to the set_relationship
      # method, then an exception {Exceptions::NonSettableRelationshipException} will
      # be raised.
      #
      # This method is called by the "magic" method of `relationship=`.
      #
      # @param [Symbol] key Relationship key.
      # @param [Object] value The new value of the relationship.
      def set_relationship(key, value)
        key = key.to_sym
        relationship = self.class.relationships_hash[key]
        return unless relationship

        raise Exceptions::NonSettableRelationshipException.new unless relationship_class(key).respond_to?(:set_relationship)
        relationship_data[key] = relationship_class(key).set_relationship(self, relationship_data[key], value)
      end
    end
  end
end
