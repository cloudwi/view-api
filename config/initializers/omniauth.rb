Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao,
           Rails.application.credentials.dig(:kakao, :client_id),
           Rails.application.credentials.dig(:kakao, :client_secret),
           scope: "account_email"
end

# 보안: OAuth 시작은 POST만 허용 (CSRF 방지)
# 콜백은 별도 라우트로 GET 허용 (OAuth 프로바이더가 GET으로 리다이렉트)
OmniAuth.config.allowed_request_methods = [ :post ]
