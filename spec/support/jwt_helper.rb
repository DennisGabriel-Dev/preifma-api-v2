module JwtHelper
  def jwt_headers(user)
    token = JWT.encode({ id: user.id }, ENV.fetch("secret_jwt"), "HS256")
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include JwtHelper, type: :request
end
