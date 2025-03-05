source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# The original asset pipeline for Rails
gem "sprockets-rails"

# Database
gem "pg"

# Web server
gem "puma", ">= 5.0"

# JavaScript & Frontend
gem "turbo-rails"
gem "stimulus-rails"
gem "vite_rails", "~> 3.0"
gem "bootstrap", "~> 5.3"
gem "cssbundling-rails", "~> 1.4"
gem 'sassc-rails'

# JSON APIs
gem "jbuilder"

# Redis for caching & Action Cable
gem "redis", ">= 4.0.1"
gem "kredis"

# Env management
gem 'dotenv-rails', groups: [:development, :test]

# Timezone support for Windows
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Boot speed optimization
gem "bootsnap", require: false

# Authentication
gem "devise", "~> 4.9"

# Background Jobs
gem "sidekiq"

# Markdown & Syntax Highlighting
gem "redcarpet", "~> 3.6"
gem "rouge", "~> 4.5"

# Form Helpers
gem "simple_form", "~> 5.3"

# AI & API integrations
gem "langchainrb", "~> 0.19.3"
gem "faraday", "~> 2.12"

# Service Objects
gem "simple_command", "~> 1.0"

# Code Quality
gem 'rubocop'
gem 'rubocop-rails'

group :development, :test do
  gem "rails-controller-testing", "~> 1.0"
  gem "debug", platforms: %i[ mri windows ]

  gem 'rspec-rails', '~> 7.0.0'
  gem "factory_bot_rails", "~> 6.4"  
  gem "shoulda-matchers", "~> 6.4"  
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
