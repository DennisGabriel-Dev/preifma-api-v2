class Api::UsersController < ApplicationController
  skip_before_action :authorize, except: [:data]

  def create
    user = User.new(user_params)
    user.password_confirmation = user.password
    if user.save
      token = JWT.encode({ id: user.id }, ENV['secret_jwt'], 'HS256')
      render json: {
        token:,
        email: user.email,
        name: user.name,
        type: user.type_user,
        current_streak: user.current_streak || 0
      }, status: :created
    elsif user.errors.attribute_names.include?(:email)
      render json: { message: "Usuário já existe!" }, status: :bad_request
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.new(user_params)
    find_user = User.find_by_email(user.email)

    if find_user.blank?
      render json: { message: "Usuário não existe!" }, status: :not_found
      return
    end

    compare_password = BCrypt::Password.new(find_user.password_digest) == user.password

    unless compare_password
      render json: { message: "Senha inválida ou usuário não encontrado!" }, status: :unauthorized
    end

    if compare_password
      token = JWT.encode({ id: find_user.id }, ENV['secret_jwt'], 'HS256')
      render json: {
        token:,
        email: find_user.email,
        name: find_user.name,
        current_streak: find_user.current_streak,
        type: find_user.type_user
      }, status: :ok
    end
  end

  def data
    user = @current_user
    count_user_answers = UserAnswer.count_user_answers(user.id)
    render json: {
      email: user.email,
      name: user.name,
      current_streak: user.current_streak,
      type: user.type_user,
      count_user_answers: count_user_answers&.count || 0,
      count_user_correct_answers: count_user_answers&.count_user_correct_answers&.count || 0
    }, status: :ok
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
