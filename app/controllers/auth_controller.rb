class AuthController < ApplicationController
  before_action :authenticate_user!, only: [ :me ]

  # OmniAuth passthru - 이 메서드는 실제로 호출되지 않음
  # OmniAuth 미들웨어가 /auth/:provider 경로를 가로채서 처리함
  def passthru
    # OmniAuth 미들웨어가 처리하지 못한 경우에만 도달
    head :not_found
  end

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
      nickname: current_user.nickname
    }
  end
end
