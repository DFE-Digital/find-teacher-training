class HandleBadMultipartFormDataMiddleware
  # Rack panics when calling params on req with invalid multipart form data
  # but we need to look at params as part of the Csharp param handling middleware
  # https://github.com/rack/rack/issues/903

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue EOFError
    [400, { 'Content-Type' => 'text/plain' }, ['Bad Request']]
  end
end
