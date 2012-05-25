require File.join(File.dirname(__FILE__), '..', 'test_helper')

class VersionTest < Test::Unit::TestCase
  module VersionTestMod
    extend VirtualBox::Version
  end

  setup do
    @lib = mock("lib")
    @vbox = mock("vbox")

    VirtualBox::Lib.stubs(:lib).returns(@lib)
    @lib.stubs(:virtualbox).returns(@vbox)

    @module = VersionTestMod
  end

  context "checking if supported version of VirtualBox" do
    should "return true if version is not nil" do
      @module.stubs(:version).returns(:foo)
      assert @module.supported?
    end

    should "return false if version is nil" do
      @module.stubs(:version).returns(nil)
      assert !@module.supported?
    end
  end

  should "return the version" do
    version = mock("version")
    @vbox.expects(:version).returns(version)
    assert_equal version, @module.version(true)
  end

  should "cache the version" do
    @vbox.expects(:version).once.returns("v")
    assert_equal "v", @module.version(true)
    assert_equal "v", @module.version
    assert_equal "v", @module.version
  end

  should "return nil if an error occurs" do
    @vbox.expects(:version).raises(LoadError)
    assert @module.version(true).nil?
  end

  should "return the revision" do
    @vbox.expects(:revision).returns(7)
    assert_equal "7", @module.revision(true)
  end

  should "cache the revision" do
    @vbox.expects(:revision).once.returns(7)
    assert_equal "7", @module.revision(true)
    assert_equal "7", @module.revision
    assert_equal "7", @module.revision
  end
end
