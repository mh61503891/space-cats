source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "bootsnap", require: false

gem "jsbundling-rails"
gem "cssbundling-rails"

gem "search_cop"
gem "ancestry"
gem "kaminari"
gem "validate_url"

gem "addressable"
gem "faraday"
gem "metainspector"
gem "mime-types"
gem "marcel"

gem "delayed_job_active_record"
gem "delayed_job_web"
gem "daemons"
gem "foreman"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pry-rails"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
