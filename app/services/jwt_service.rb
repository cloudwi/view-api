# frozen_string_literal: true

class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base
  ALGORITHM = "HS256"
  # JWT 토큰 유효기간 (기본값: 24시간)
  TOKEN_EXPIRATION = ENV.fetch("JWT_EXPIRATION_HOURS", "24").to_i.hours

  def self.encode(payload, exp = TOKEN_EXPIRATION.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
