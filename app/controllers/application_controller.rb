class ApplicationController < ActionController::API
  before_action :authorize

  def auth_reader
    request.headers['Authorization']
  end

  def decode_token
    if auth_reader
      token = auth_reader.split(' ')[1]
      begin
        JWT.decode(token, ENV['secret_jwt'], true, algorithm: 'HS256')
      rescue
        nil
      end
    end
  end

  def current_user
    if decode_token
      user_id = decode_token[0]['id']
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authorize
    render json: { error: 'Não autorizado' }, status: :unauthorized unless current_user
  end
end
