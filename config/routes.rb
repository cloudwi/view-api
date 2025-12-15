Rails.application.routes.draw do
  # Swagger UI - 운영 환경에서는 접근 차단
  unless Rails.env.production?
    mount Rswag::Ui::Engine => "/api-docs"
    mount Rswag::Api::Engine => "/api-docs"
  end
  # OmniAuth routes
  get "/auth/:provider", to: "auth#passthru"
  get "/auth/kakao/callback", to: "auth#kakao_callback"
  get "auth/me", to: "auth#me"

  # Categories API
  resources :categories, only: [ :index ]

  # Views API
  resources :views, only: [ :index, :show, :create, :update, :destroy ] do
    resource :vote, only: [ :create, :destroy ]
    resources :comments, only: [ :index, :create, :update, :destroy ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
