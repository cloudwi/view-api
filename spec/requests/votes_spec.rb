# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Votes API', type: :request do
  path '/views/{view_id}/vote' do
    parameter name: :view_id, in: :path, type: :integer, description: '뷰 ID'

    post '투표하기' do
      tags 'Votes'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :vote, in: :body, schema: {
        type: :object,
        properties: {
          view_option_id: { type: :integer, description: '투표할 선택지 ID' }
        },
        required: %w[view_option_id]
      }

      response '201', '투표 성공' do
        schema '$ref' => '#/components/schemas/VoteResult'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:vote) { { view_option_id: 1 } }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view_id) { 1 }
        let(:vote) { { view_option_id: 1 } }

        run_test!
      end

      response '404', '뷰 또는 선택지를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 99999 }
        let(:vote) { { view_option_id: 1 } }

        run_test!
      end

      response '422', '유효성 검사 실패 (이미 투표함)' do
        schema '$ref' => '#/components/schemas/ValidationErrors'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:vote) { { view_option_id: 1 } }

        run_test!
      end
    end

    delete '투표 취소' do
      tags 'Votes'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', '투표 취소 성공' do
        schema '$ref' => '#/components/schemas/VoteResult'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view_id) { 1 }

        run_test!
      end

      response '404', '뷰 또는 투표를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 99999 }

        run_test!
      end
    end
  end
end
