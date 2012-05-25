module VirtualBox
  # Represents the VRDP Server settings of a {VM}.
  class VRDPServer < AbstractModel
    attribute :parent, :readonly => true, :property => false
    attribute :enabled, :boolean => true
    attribute :ports
    attribute :net_address
    attribute :auth_type
    attribute :auth_timeout
    attribute :allow_multi_connection, :boolean => true
    attribute :reuse_single_connection, :boolean => true

    class << self
      # Populates a relationship with another model.
      #
      # **This method typically won't be used except internally.**
      #
      # @return [VRDPServer]
      def populate_relationship(caller, imachine)
        data = new(caller, imachine.vrdp_server)
      end

      # Saves the relationship.
      #
      # **This method typically won't be used except internally.**
      def save_relationship(caller, instance)
        instance.save
      end
    end

    def initialize(parent, vrdp_settings)
      write_attribute(:parent, parent)

      # Load the attributes and mark the whole thing as existing
      load_interface_attributes(vrdp_settings)
      clear_dirty!
      existing_record!
    end

    def validate
      super

      validates_inclusion_of :enabled, :allow_multi_connection, :reuse_single_connection, :in => [true, false]
      validates_format_of :ports, :with => /^[\d\s\-\.]+$/, :message => "must only contain numbers, spaces, dashes or periods."
      validates_format_of :net_address, :with => /^[\w\d\-\.]+$/, :message => "must only contain latters, numbers, dashes or periods."
      validates_inclusion_of :auth_type, :in => COM::Util.versioned_interface(:VRDPAuthType).map
      validates_numericality_of :auth_timeout
    end

    def save
      parent.with_open_session do |session|
        machine = session.machine

        # Save them
        save_changed_interface_attributes(machine.vrdp_server)
      end
    end
  end
end
