# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/categories' do
    get '카테고리 목록 조회' do
      tags 'Categories'
      produces 'application/json'
      description '활성화된 모든 카테고리를 display_order 순으로 반환합니다.'

      response '200', '카테고리 목록 반환' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Category' }
                 },
                 meta: { type: :object }
               },
               required: %w[data]

        before do
          create(:category, :daily)
          create(:category, :food)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data'].size).to eq(2)
        end
      end
    end
  end
end
