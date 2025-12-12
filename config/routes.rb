Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # OmniAuth callbacks
  get "/auth/kakao/callback", to: "auth#kakao_callback"
  get "auth/me", to: "auth#me"

  # Views API
  resources :views, only: [ :index, :show, :create, :update, :destroy ] do
    resource :vote, only: [ :create, :destroy ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
