Rails.application.routes.draw do
  # OmniAuth callbacks
  get "/auth/kakao/callback", to: "auth#kakao_callback"
  get "auth/me", to: "auth#me"

  # Views API
  resources :views, only: [ :index, :show, :create, :update, :destroy ]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
