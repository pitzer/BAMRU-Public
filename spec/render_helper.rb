require 'spec_helper'
require 'erb'

class EnvContext
  def env
    {}
  end
end

class RenderContext
  include Sinatra::AppHelpers
  def request
    EnvContext.new
  end
  def context
    binding
  end
end