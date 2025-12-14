# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/views/{view_id}/comments' do
    parameter name: :view_id, in: :path, type: :integer, description: '뷰 ID'

    get '댓글 목록 조회' do
      tags 'Comments'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', '댓글 목록 반환' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Comment' }
                 }
               },
               required: %w[data]

        let(:view_id) { 1 }

        run_test!
      end

      response '404', '뷰를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:view_id) { 99999 }

        run_test!
      end
    end

    post '댓글 작성' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string, description: '댓글 내용 (최소 1자, 최대 2000자)' }
            },
            required: %w[content]
          }
        },
        required: %w[comment]
      }

      response '201', '댓글 작성 성공' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Comment' }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:comment) { { comment: { content: '좋은 의견이네요!' } } }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view_id) { 1 }
        let(:comment) { {} }

        run_test!
      end

      response '404', '뷰를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 99999 }
        let(:comment) { { comment: { content: '댓글 내용' } } }

        run_test!
      end

      response '422', '유효성 검사 실패' do
        schema '$ref' => '#/components/schemas/ValidationErrors'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:comment) { { comment: { content: '' } } }

        run_test!
      end
    end
  end

  path '/views/{view_id}/comments/{id}' do
    parameter name: :view_id, in: :path, type: :integer, description: '뷰 ID'
    parameter name: :id, in: :path, type: :integer, description: '댓글 ID'

    patch '댓글 수정' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string, description: '댓글 내용 (최소 1자, 최대 2000자)' }
            },
            required: %w[content]
          }
        },
        required: %w[comment]
      }

      response '200', '댓글 수정 성공' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Comment' }
               },
               required: %w[data]

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 1 }
        let(:comment) { { comment: { content: '수정된 댓글입니다' } } }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view_id) { 1 }
        let(:id) { 1 }
        let(:comment) { {} }

        run_test!
      end

      response '403', '권한 없음 (본인의 댓글만 수정 가능)' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 1 }
        let(:comment) { { comment: { content: '수정 내용' } } }

        run_test!
      end

      response '404', '댓글을 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 99999 }
        let(:comment) { { comment: { content: '수정 내용' } } }

        run_test!
      end

      response '422', '유효성 검사 실패' do
        schema '$ref' => '#/components/schemas/ValidationErrors'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 1 }
        let(:comment) { { comment: { content: '' } } }

        run_test!
      end
    end

    delete '댓글 삭제' do
      tags 'Comments'
      security [ bearer_auth: [] ]

      response '204', '삭제 성공' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 1 }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view_id) { 1 }
        let(:id) { 1 }

        run_test!
      end

      response '403', '권한 없음 (본인의 댓글만 삭제 가능)' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 1 }

        run_test!
      end

      response '404', '댓글을 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view_id) { 1 }
        let(:id) { 99999 }

        run_test!
      end
    end
  end
end
