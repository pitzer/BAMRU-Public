require 'render_helper'

describe "admin_home.erb" do
  before(:each) do
    @page = RenderContext.new
    template = File.read("views/admin_home.erb")
    @engine = ERB.new(template)
  end

  it "should render the admin page" do
#    body = @engine.result(@page.context)
#    body.should_not be_nil
  end
end

