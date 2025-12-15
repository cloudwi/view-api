# frozen_string_literal: true

module ApiHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def expect_success_response
    expect(response).to have_http_status(:ok)
    expect(json_response).to have_key(:data)
  end

  def expect_created_response
    expect(response).to have_http_status(:created)
    expect(json_response).to have_key(:data)
  end

  def expect_error_response(status, code = nil)
    expect(response).to have_http_status(status)
    expect(json_response).to have_key(:error)
    expect(json_response[:error][:code]).to eq(code) if code
  end

  def expect_unauthorized
    expect_error_response(:unauthorized, "UNAUTHORIZED")
  end

  def expect_not_found(resource)
    expect_error_response(:not_found, "#{resource.upcase}_NOT_FOUND")
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :request
end
