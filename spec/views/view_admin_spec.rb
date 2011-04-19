require 'render_helper'

describe "admin.erb" do
  before(:each) do
    @page = RenderContext.new
    template = File.read("views/admin.erb")
    @engine = ERB.new(template)
  end

  it "should render a page" do
    body = @engine.result(@page.context)
    body.should include("BAMRU")
  end
end

