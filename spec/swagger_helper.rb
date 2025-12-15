# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'View API',
        version: 'v1',
        description: '의견 투표 서비스 API'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        },
        {
          url: 'https://api.example.com',
          description: 'Production server'
        }
      ],
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          User: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              nickname: { type: :string }
            },
            required: %w[id nickname]
          },
          Author: {
            type: :object,
            properties: {
              id: { type: :integer },
              nickname: { type: :string }
            },
            required: %w[id nickname]
          },
          ViewOption: {
            type: :object,
            properties: {
              id: { type: :integer },
              content: { type: :string },
              votes_count: { type: :integer }
            },
            required: %w[id content votes_count]
          },
          MyVote: {
            type: :object,
            nullable: true,
            properties: {
              option_id: { type: :integer }
            }
          },
          Comment: {
            type: :object,
            properties: {
              id: { type: :integer },
              content: { type: :string },
              author: { '$ref' => '#/components/schemas/Author' },
              created_at: { type: :string, format: 'date-time' }
            },
            required: %w[id content author created_at]
          },
          ViewListItem: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              category: {
                type: :string,
                enum: %w[daily food relationship work hobby fashion game travel etc],
                description: '카테고리'
              },
              author: { '$ref' => '#/components/schemas/Author' },
              options: {
                type: :array,
                items: { '$ref' => '#/components/schemas/ViewOption' }
              },
              total_votes: { type: :integer },
              my_vote: { '$ref' => '#/components/schemas/MyVote' },
              comments_count: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              edited: { type: :boolean }
            },
            required: %w[id title category author options total_votes created_at updated_at edited]
          },
          ViewDetail: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              category: {
                type: :string,
                enum: %w[daily food relationship work hobby fashion game travel etc],
                description: '카테고리'
              },
              author: { '$ref' => '#/components/schemas/Author' },
              options: {
                type: :array,
                items: { '$ref' => '#/components/schemas/ViewOption' }
              },
              total_votes: { type: :integer },
              my_vote: { '$ref' => '#/components/schemas/MyVote' },
              comments: {
                type: :array,
                items: { '$ref' => '#/components/schemas/Comment' }
              },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              edited: { type: :boolean }
            },
            required: %w[id title category author options total_votes comments created_at updated_at edited]
          },
          ViewInput: {
            type: :object,
            properties: {
              view: {
                type: :object,
                properties: {
                  title: { type: :string },
                  view_options_attributes: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        content: { type: :string },
                        _destroy: { type: :boolean }
                      },
                      required: %w[content]
                    }
                  }
                },
                required: %w[title view_options_attributes]
              }
            },
            required: %w[view]
          },
          VoteInput: {
            type: :object,
            properties: {
              view_option_id: { type: :integer }
            },
            required: %w[view_option_id]
          },
          VoteResult: {
            type: :object,
            properties: {
              view_id: { type: :integer },
              options: {
                type: :array,
                items: { '$ref' => '#/components/schemas/ViewOption' }
              },
              total_votes: { type: :integer },
              my_vote: { '$ref' => '#/components/schemas/MyVote' }
            },
            required: %w[view_id options total_votes]
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string }
            }
          },
          ValidationErrors: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string }
              }
            }
          },
          PaginationMeta: {
            type: :object,
            properties: {
              per_page: { type: :integer },
              has_next: { type: :boolean },
              next_cursor: { type: :string, nullable: true }
            },
            required: %w[per_page has_next]
          },
          ViewListResponse: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/ViewListItem' }
              },
              meta: { '$ref' => '#/components/schemas/PaginationMeta' }
            },
            required: %w[data meta]
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
