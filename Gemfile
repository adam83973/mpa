source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.1'

gem 'rails', '~> 5.0', '>= 5.0.2'

gem 'pg'

gem 'ahoy_email'
gem 'attr_encrypted', '3.0.1'
gem 'autoprefixer-rails'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'bootstrap-switch-rails'
gem 'carrierwave-aws'
gem 'chartjs-ror'
gem 'check_appointments'
gem 'chosen-rails'
gem 'coffee-rails', '~> 4.2'
gem 'd3-rails'
gem 'devise'
gem 'devise_invitable'
gem "factory_girl_rails", require: false, group: :test
gem 'faker', '~> 1.7', '>= 1.7.3'
gem 'font-awesome-rails'
gem 'google-api-client', '<0.9'
gem 'humanize'
gem 'httparty'
gem 'infusionsoft', '1.1.7b'
gem 'jbuilder', '~> 2.5'
gem 'json'
gem 'jquery-fileupload-rails'
gem 'jquery-slimscroll-rails'
gem 'jquery-rails'
gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails'
gem 'jquery-ui-rails'
gem 'jscolor-rails'
gem 'lodash-rails'
gem 'mail_form'
gem 'mini_magick', '3.8.0'
gem "nested_form", git: "https://github.com/ryanb/nested_form.git"
# gem 'normalize-rails'
# gem 'modernizr-rails'
gem 'oj'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'paper_trail', '~> 4.0.0', group: [:production, :development, :test]
gem 'populator'
gem 'progress_bar'
gem 'puma', '~> 3.0'
gem 'rack-timeout'
# gem 'rails-observers'
gem 'rest-client'
gem 'rmagick', :require => 'RMagick'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'selectivizr-rails'
gem 'sendgrid-ruby'
gem 'simple_form'
gem 'sunspot_rails'
gem 'sunspot_solr', group: [:development, :production]
gem 'test-unit'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate', '~> 3.0.6'
gem 'woocommerce_api'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'bullet'
  gem 'letter_opener'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
