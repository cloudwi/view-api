require Rails.root.join("lib/omniauth/strategies/kakao")

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao,
           Rails.application.credentials.dig(:kakao, :client_id),
           client_secret: Rails.application.credentials.dig(:kakao, :client_secret)
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
