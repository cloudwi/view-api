class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def kakao
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      token = JwtService.encode(user_id: @user.id)

      redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3001')}/auth/callback?token=#{token}",
                  allow_other_host: true
    else
      redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3001')}/auth/failure?message=login_failed",
                  allow_other_host: true
    end
  end

  def failure
    redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3001')}/auth/failure?message=#{failure_message}",
                allow_other_host: true
  end
end
