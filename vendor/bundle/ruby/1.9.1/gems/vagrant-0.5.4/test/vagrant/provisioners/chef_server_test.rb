require "test_helper"

class ChefServerProvisionerTest < Test::Unit::TestCase
  setup do
    @action_env = Vagrant::Action::Environment.new(mock_environment)
    @action_env.env.vm = mock_vm

    @action = Vagrant::Provisioners::ChefServer.new(@action_env)
    @env = @action.env
    @vm = @action.vm
  end

  context "provisioning" do
    should "run the proper sequence of methods in order" do
      prov_seq = sequence("prov_seq")
      @action.expects(:verify_binary).with("chef-client").once.in_sequence(prov_seq)
      @action.expects(:chown_provisioning_folder).once.in_sequence(prov_seq)
      @action.expects(:create_client_key_folder).once.in_sequence(prov_seq)
      @action.expects(:upload_validation_key).once.in_sequence(prov_seq)
      @action.expects(:setup_json).once.in_sequence(prov_seq)
      @action.expects(:setup_server_config).once.in_sequence(prov_seq)
      @action.expects(:run_chef_client).once.in_sequence(prov_seq)
      @action.provision!
    end
  end

  context "preparing" do
    setup do
      File.stubs(:file?).returns(true)
    end

    should "not raise an exception if validation_key_path is set" do
      @env = mock_environment do |config|
        config.chef.validation_key_path = "7"
      end

      @action.stubs(:env).returns(@env)

      @action.prepare
      assert !@action_env.error?
    end

    should "eraise an exception if validation_key_path is nil" do
      @env = mock_environment do |config|
        config.chef.validation_key_path = nil
      end

      @action.stubs(:env).returns(@env)

      @action.prepare
      assert @action_env.error?
      assert_equal :chef_server_validation_key_required, @action_env.error.first
    end

    should "not raise an exception if validation_key_path does exist" do
      @env = mock_environment do |config|
        config.chef.validation_key_path = "7"
      end

      @action.stubs(:env).returns(@env)
      @action.stubs(:validation_key_path).returns("9")

      File.expects(:file?).with(@action.validation_key_path).returns(true)
      @action.prepare
      assert !@action_env.error?
    end

    should "raise an exception if validation_key_path doesn't exist" do
      @env = mock_environment do |config|
        config.chef.validation_key_path = "7"
      end

      @action.stubs(:env).returns(@env)
      @action.stubs(:validation_key_path).returns("9")

      File.expects(:file?).with(@action.validation_key_path).returns(false)
      @action.prepare
      assert @action_env.error?
      assert_equal :chef_server_validation_key_doesnt_exist, @action_env.error.first
    end

    should "not raise an exception if chef_server_url is set" do
      @env = mock_environment do |config|
        config.chef.chef_server_url = "7"
      end

      @action.stubs(:env).returns(@env)

      @action.prepare
      assert !@action_env.error?
    end

    should "raise an exception if chef_server_url is nil" do
      @env = mock_environment do |config|
        config.chef.chef_server_url = nil
      end

      @action.stubs(:env).returns(@env)

      @action.prepare
      assert @action_env.error?
      assert_equal :chef_server_url_required, @action_env.error.first
    end
  end

  context "creating the client key folder" do
    setup do
      @raw_path = "/foo/bar/baz.pem"
      @env.config.chef.client_key_path = @raw_path

      @path = Pathname.new(@raw_path)
    end

    should "create the folder using the dirname of the path" do
      ssh = mock("ssh")
      ssh.expects(:exec!).with("sudo mkdir -p #{@path.dirname}").once
      @vm.ssh.expects(:execute).yields(ssh)
      @action.create_client_key_folder
    end
  end

  context "uploading the validation key" do
    should "upload the validation key to the provisioning path" do
      @action.expects(:validation_key_path).once.returns("foo")
      @action.expects(:guest_validation_key_path).once.returns("bar")
      @vm.ssh.expects(:upload!).with("foo", "bar").once
      @action.upload_validation_key
    end
  end

  context "the validation key path" do
    should "expand the configured key path" do
      result = mock("result")
      File.expects(:expand_path).with(@env.config.chef.validation_key_path, @env.root_path).once.returns(result)
      assert_equal result, @action.validation_key_path
    end
  end

  context "the guest validation key path" do
    should "be the provisioning path joined with validation.pem" do
      result = mock("result")
      File.expects(:join).with(@env.config.chef.provisioning_path, "validation.pem").once.returns(result)
      assert_equal result, @action.guest_validation_key_path
    end
  end

  context "generating and uploading chef client configuration file" do
    setup do
      @action.stubs(:guest_validation_key_path).returns("foo")
    end

    should "call setup_config with proper variables" do
      @action.expects(:setup_config).with("chef_server_client", "client.rb", {
        :node_name => @env.config.chef.node_name,
        :chef_server_url => @env.config.chef.chef_server_url,
        :validation_client_name => @env.config.chef.validation_client_name,
        :validation_key => @action.guest_validation_key_path,
        :client_key => @env.config.chef.client_key_path
      })

      @action.setup_server_config
    end
  end

  context "running chef client" do
    setup do
      @ssh = mock("ssh")
      @vm.ssh.stubs(:execute).yields(@ssh)
    end

    should "cd into the provisioning directory and run chef client" do
      @ssh.expects(:exec!).with("cd #{@env.config.chef.provisioning_path} && sudo -E chef-client -c client.rb -j dna.json").once
      @action.run_chef_client
    end

    should "check the exit status if that is given" do
      @ssh.stubs(:exec!).yields(nil, :exit_status, :foo)
      @ssh.expects(:check_exit_status).with(:foo, anything).once
      @action.run_chef_client
    end
  end
end
