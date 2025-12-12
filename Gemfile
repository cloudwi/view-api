source "https://rubygems.org"

gem "rails", "~> 8.1.1"
gem "sqlite3", ">= 2.1", group: [ :development, :test ]
gem "pg", group: :production
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "rack-cors"

# Authentication
gem "omniauth-kakao-oauth2"
gem "omniauth-rails_csrf_protection"
gem "jwt"

# API Documentation
gem "rswag-api"
gem "rswag-ui"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "rswag-specs"
end
