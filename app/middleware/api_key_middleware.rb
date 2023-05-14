# app/middleware/api_key_middleware.rb

class ApiKeyMiddleware
  def initialize(app)
    @app = app
  end

  def call(headers)
    api_key = headers['ApiKeyAuth']
    return [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']] unless api_key

    user = User.find_by(api_key: api_key)
    return [401, { 'Content-Type' => 'text/plain' }, ['Invalid API key']] unless user

    env['user'] = user
    @app.call(env)
  end
end