module VirtualBox
  class DHCPServer < AbstractModel
    attribute :parent, :readonly => true, :property => false
    attribute :parent_collection, :readonly => true, :property => false
    attribute :interface, :readonly => true, :property => false
    attribute :enabled
    attribute :ip_address
    attribute :network_mask
    attribute :network_name, :readonly => true
    attribute :lower_ip
    attribute :upper_ip

    class << self
      # Populates a relationship with another model.
      #
      # **This method typically won't be used except internally.**
      #
      # @return [Array<DHCPServer>]
      def populate_relationship(caller, servers)
        relation = Proxies::Collection.new(caller, self)

        servers.each do |interface|
          relation << new(interface)
        end

        relation
      end

      # Creates a DHCP server for the given network name.
      # This method should not be called directly, its recommended that you call
      # the `create` method on the `dhcp_servers` relationship on
      # `VirtualBox::Global` object.
      def create(proxy, network_name)
        interface = proxy.parent.lib.virtualbox.create_dhcp_server(network_name)
        new(interface)
      end
    end

    def initialize(raw)
      initialize_attributes(raw)
    end

    def initialize_attributes(raw)
      write_attribute(:interface, raw)

      load_interface_attributes(interface)
      existing_record!
    end

    def added_to_relationship(proxy)
      write_attribute(:parent, proxy.parent)
      write_attribute(:parent_collection, proxy)
    end

    def save
      configs = [:ip_address, :network_mask, :lower_ip, :upper_ip]
      configs_changed = configs.map { |key| changed?(key) }.any? { |i| i }

      if configs_changed
        interface.set_configuration(ip_address, network_mask, lower_ip, upper_ip)

        # Clear the dirtiness so that the abstract model doesn't try
        # to save the attributes
        configs.each do |key|
          clear_dirty!(key)
        end
      end

      save_changed_interface_attributes(interface)
    end

    # Removes the DHCP server.
    def destroy
      parent.lib.virtualbox.remove_dhcp_server(interface)
      parent_collection.delete(self, true)
      true
    end

    # Returns the host network associated with this DHCP server, if it
    # exists.
    def host_network
      return nil unless network_name =~ /^HostInterfaceNetworking-(.+?)$/

      parent.host.network_interfaces.detect do |i|
        i.interface_type == :host_only && i.name == $1.to_s
      end
    end
  end
end
