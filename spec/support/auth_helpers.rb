# frozen_string_literal: true

module AuthHelpers
  def auth_headers(user)
    token = JwtService.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  end

  def auth_header_for(user)
    auth_headers(user)
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
