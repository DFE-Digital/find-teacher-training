module Rack
  class HandleBadEncoding
    def initialize(app)
      @app = app
    end

    def call(env)
      if %w[/location-suggestions /provider-suggestions].include?(env["REQUEST_PATH"])
        begin
          Rack::Utils.parse_nested_query(env["QUERY_STRING"].to_s)
        rescue Rack::Utils::InvalidParameterError
          env["QUERY_STRING"] = ""
        end
      end

      @app.call(env)
    end
  end
end
