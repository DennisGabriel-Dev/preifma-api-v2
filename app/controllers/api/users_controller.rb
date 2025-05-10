class Api::UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: { id: user.id }, status: :created
    else
      render json: { message: "Error creating user" }, status: :unauthorized
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
