module Vagrant
  module Provisioners
    # The base class for a "provisioner." A provisioner is responsible for
    # provisioning a Vagrant system. This has been abstracted out to provide
    # support for multiple solutions such as Chef Solo, Chef Client, and
    # Puppet.
    class Base
      include Vagrant::Util

      # The environment which provisioner is running in. This is a
      # {Vagrant::Action::Environment}
      attr_reader :action_env

      def initialize(env)
        @action_env = env
      end

      # Returns the actual {Vagrant::Environment} which this provisioner
      # represents.
      #
      # @return [Vagrant::Environment]
      def env
        action_env.env
      end

      # Returns the VM which this provisioner is working on.
      #
      # @return [Vagrant::VM]
      def vm
        env.vm
      end

      # This method returns the environment's logger as a convenience
      # method.
      def logger
        env.logger
      end

      # This is the method called to "prepare" the provisioner. This is called
      # before any actions are run by the action runner (see {Vagrant::Actions::Runner}).
      # This can be used to setup shared folders, forward ports, etc. Whatever is
      # necessary on a "meta" level.
      def prepare; end

      # This is the method called to provision the system. This method
      # is expected to do whatever necessary to provision the system (create files,
      # SSH, etc.)
      def provision!; end
    end
  end
end
