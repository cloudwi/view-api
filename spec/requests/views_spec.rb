# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Views API', type: :request do
  path '/views' do
    get '뷰(의견) 목록 조회' do
      tags 'Views'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :q, in: :query, type: :string, required: false, description: '제목 검색어'
      parameter name: :sort, in: :query, type: :string, required: false,
                enum: %w[latest most_votes],
                description: '정렬 기준 (latest: 최신순, most_votes: 투표 많은 순)'
      parameter name: :per_page, in: :query, type: :integer, required: false,
                description: '페이지당 항목 수 (기본값: 20, 최대: 100)'
      parameter name: :cursor, in: :query, type: :string, required: false,
                description: '다음 페이지를 위한 커서'

      response '200', '뷰 목록 반환' do
        schema '$ref' => '#/components/schemas/ViewListResponse'

        run_test!
      end
    end

    post '새 뷰(의견) 생성' do
      tags 'Views'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :view, in: :body, schema: {
        type: :object,
        properties: {
          view: {
            type: :object,
            properties: {
              title: { type: :string, description: '뷰 제목' },
              view_options_attributes: {
                type: :array,
                description: '선택지 목록 (최소 2개)',
                items: {
                  type: :object,
                  properties: {
                    content: { type: :string, description: '선택지 내용' }
                  },
                  required: %w[content]
                }
              }
            },
            required: %w[title view_options_attributes]
          }
        },
        required: %w[view]
      }

      response '201', '뷰 생성 성공' do
        schema '$ref' => '#/components/schemas/ViewListItem'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view) do
          {
            view: {
              title: '짜장면 vs 짬뽕',
              view_options_attributes: [
                { content: '짜장면' },
                { content: '짬뽕' }
              ]
            }
          }
        end

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:view) { {} }

        run_test!
      end

      response '422', '유효성 검사 실패' do
        schema '$ref' => '#/components/schemas/ValidationErrors'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:view) { { view: { title: '' } } }

        run_test!
      end
    end
  end

  path '/views/{id}' do
    parameter name: :id, in: :path, type: :integer, description: '뷰 ID'

    get '뷰(의견) 상세 조회' do
      tags 'Views'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', '뷰 상세 정보 반환 (댓글 포함)' do
        schema '$ref' => '#/components/schemas/ViewDetail'

        let(:id) { 1 }

        run_test!
      end

      response '404', '뷰를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:id) { 99999 }

        run_test!
      end
    end

    patch '뷰(의견) 수정' do
      tags 'Views'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :view, in: :body, schema: {
        type: :object,
        properties: {
          view: {
            type: :object,
            properties: {
              title: { type: :string, description: '뷰 제목' },
              view_options_attributes: {
                type: :array,
                description: '선택지 목록',
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, description: '기존 선택지 ID (수정 시)' },
                    content: { type: :string, description: '선택지 내용' },
                    _destroy: { type: :boolean, description: '선택지 삭제 여부' }
                  }
                }
              }
            }
          }
        },
        required: %w[view]
      }

      response '200', '뷰 수정 성공' do
        schema '$ref' => '#/components/schemas/ViewListItem'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 1 }
        let(:view) { { view: { title: '수정된 제목' } } }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:id) { 1 }
        let(:view) { {} }

        run_test!
      end

      response '403', '권한 없음 (본인의 뷰만 수정 가능)' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 1 }
        let(:view) { { view: { title: '수정된 제목' } } }

        run_test!
      end

      response '404', '뷰를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 99999 }
        let(:view) { {} }

        run_test!
      end
    end

    delete '뷰(의견) 삭제' do
      tags 'Views'
      security [ bearer_auth: [] ]

      response '204', '삭제 성공' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 1 }

        run_test!
      end

      response '401', '인증 실패' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { '' }
        let(:id) { 1 }

        run_test!
      end

      response '403', '권한 없음 (본인의 뷰만 삭제 가능)' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 1 }

        run_test!
      end

      response '404', '뷰를 찾을 수 없음' do
        schema '$ref' => '#/components/schemas/Error'

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { 'valid_token' }
        let(:id) { 99999 }

        run_test!
      end
    end
  end
end
