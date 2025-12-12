# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/auth/me' do
    get '현재 로그인한 사용자 정보 조회' do
      tags 'Auth'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', '사용자 정보 반환' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 email: { type: :string },
                 nickname: { type: :string }
               },
               required: %w[id nickname]

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }

        run_test!
      end
    end
  end
end
