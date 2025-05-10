class Api::UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      token = JWT.encode({ id: user.id }, ENV['secret_jwt'], 'HS256')
      render json: {token:, email: user.email }, status: :created
    elsif user.errors.attribute_names.include? :email
      render json: { message: "Usuário já existe!" }, status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :email, :password, :name ])
    end
end
