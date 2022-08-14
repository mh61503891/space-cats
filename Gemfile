source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "importmap-rails"
gem "validate_url"

# gem 'sass-rails', '~> 5.0'
# gem 'uglifier', '>= 1.3.0'
# gem 'webpacker'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "addressable"
gem "faraday"
gem "delayed_job_active_record"
gem "daemons"
gem "foreman"
gem "delayed_job_web"
gem "search_cop"
gem "metainspector"
gem "mime-types"
gem "ancestry"
gem "kaminari"

gem "bootsnap", ">= 1.1.0", require: false

# gem "bootstrap"
gem "jquery-rails"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "pry-rails"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
