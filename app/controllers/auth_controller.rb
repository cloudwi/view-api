class AuthController < ApplicationController
  before_action :authenticate_user!, only: [:me]

  def kakao_callback
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user.persisted?
      token = JwtService.encode(user_id: @user.id)
      redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3001')}/auth/callback?token=#{token}",
                  allow_other_host: true
    else
      redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3001')}/auth/failure?message=login_failed",
                  allow_other_host: true
    end
  end

  def me
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      profile_image: current_user.profile_image
    }
  end

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render_unauthorized unless token

    decoded = JwtService.decode(token)
    return render_unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    render_unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
