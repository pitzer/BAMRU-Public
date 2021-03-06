module Sinatra
  class CacheAssets

    VERSION = "0.0.3"

    attr_reader :app, :options

    def initialize(app, options={})
      @app = app
      @options = options
    end

    def call(env)
      code, headers, body = app.call(env)
      headers["Cache-Control"] = "public, max-age=#{duration}" if env['sinatra.static_file']
      [ code, headers, body ]
    end

  private

    def duration
      options[:max_age] || 86400
    end

  end
end

