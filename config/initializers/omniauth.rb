Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao,
           Rails.application.credentials.dig(:kakao, :client_id),
           Rails.application.credentials.dig(:kakao, :client_secret),
           scope: "account_email"
end

# OAuth 인증 시작 및 콜백 모두 GET 요청 허용
# 보안: 프로덕션에서는 state 파라미터를 통한 CSRF 방지 권장
OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.silence_get_warning = true
