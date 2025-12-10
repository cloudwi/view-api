Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao,
           Rails.application.credentials.dig(:kakao, :client_id),
           Rails.application.credentials.dig(:kakao, :client_secret),
           scope: "account_email"
end

OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.silence_get_warning = true
