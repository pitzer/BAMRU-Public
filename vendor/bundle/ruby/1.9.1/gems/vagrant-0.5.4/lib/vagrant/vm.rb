module Vagrant
  class VM
    include Vagrant::Util

    attr_reader :env
    attr_reader :system
    attr_reader :name
    attr_accessor :vm

    class << self
      # Finds a virtual machine by a given UUID and either returns
      # a Vagrant::VM object or returns nil.
      def find(uuid, env=nil, vm_name=nil)
        vm = VirtualBox::VM.find(uuid)
        new(:vm => vm, :env => env, :vm_name => vm_name)
      end
    end

    def initialize(opts=nil)
      defaults = {
        :vm => nil,
        :env => nil,
        :vm_name => nil
      }

      opts = defaults.merge(opts || {})

      @vm = opts[:vm]
      @name = opts[:vm_name]

      if !opts[:env].nil?
        # We have an environment, so we create a new child environment
        # specifically for this VM. This step will load any custom
        # config and such.
        @env = Vagrant::Environment.new({
          :cwd => opts[:env].cwd,
          :parent => opts[:env],
          :vm_name => opts[:vm_name],
          :vm => self
        }).load!

        # Load the associated system.
        load_system!
      end
    end

    # Loads the system associated with the VM. The system class is
    # responsible for OS-specific functionality. More information
    # can be found by reading the documentation on {Vagrant::Systems::Base}.
    #
    # **This method should never be called manually.**
    def load_system!
      system = env.config.vm.system

      if system.is_a?(Class)
        @system = system.new(self)
        error_and_exit(:system_invalid_class, :system => system.to_s) unless @system.is_a?(Systems::Base)
      elsif system.is_a?(Symbol)
        # Hard-coded internal systems
        mapping = { :linux => Systems::Linux }

        if !mapping.has_key?(system)
          error_and_exit(:system_unknown_type, :system => system.to_s)
          return # for tests
        end

        @system = mapping[system].new(self)
      else
        error_and_exit(:system_unspecified)
      end
    end

    # Access the {Vagrant::SSH} object associated with this VM.
    # On the initial call, this will initialize the object. On
    # subsequent calls it will reuse the existing object.
    def ssh
      @ssh ||= SSH.new(env)
    end

    # Returns a boolean true if the VM has been created, otherwise
    # returns false.
    #
    # @return [Boolean]
    def created?
      !vm.nil?
    end

    def uuid
      vm ? vm.uuid : nil
    end

    def reload!
      @vm = VirtualBox::VM.find(@vm.uuid)
    end

    def package(options=nil)
      env.actions.run(:package, options)
    end

    def up(options=nil)
      env.actions.run(:up, options)
    end

    def start
      return if @vm.running?
      return resume if @vm.saved?

      env.actions.run(:start)
    end

    def halt(options=nil)
      env.actions.run(:halt, options)
    end

    def reload
      env.actions.run(:reload)
    end

    def provision
      env.actions.run(:provision)
    end

    def destroy
      env.actions.run(:destroy)
    end

    def suspend
      env.actions.run(:suspend)
    end

    def resume
      env.actions.run(:resume)
    end

    def saved?
      @vm.saved?
    end

    def powered_off?; @vm.powered_off? end
  end
end
