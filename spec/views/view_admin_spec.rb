require 'render_helper'

describe "admin_home.erb" do
  before(:each) do
    @page = RenderContext.new
    base = File.dirname(File.expand_path(__FILE__))
    @engine = ERB.new(base + "/../../views/admin_home.erb")
  end

  it "should render the admin page" do
#    body = @engine.result(@page.context)
#    body.should_not be_nil
  end
end

