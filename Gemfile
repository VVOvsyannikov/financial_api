source "https://rubygems.org"

ruby "~> 3.4.2"

gem "rails", "~> 8.0.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

gem "bootsnap", require: false
gem "jwt"

group :development, :test do
  gem "bundler-audit", require: false
  gem "brakeman"
  gem "debug", require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end
