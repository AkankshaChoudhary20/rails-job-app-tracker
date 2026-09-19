source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.3"

# Database
gem "pg", "~> 1.5"

# Web server
gem "puma", ">= 5.0"

# Hotwire
gem "turbo-rails", "~> 2.0"
gem "stimulus-rails", "~> 1.3"

# Asset pipeline (import maps, no Node/webpack needed)
gem "importmap-rails", "~> 2.0"
gem "sprockets-rails"

# Authentication primitive used by has_secure_password
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
