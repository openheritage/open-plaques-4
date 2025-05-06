source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]


gem "aasm" # manage object state
# gem "activerecord-postgis-adapter' # link to Postgis geo database
gem "aws-sdk-comprehend"
gem "aws-sdk-s3", require: false
gem "aws-sdk-translate"
gem "bootsnap", require: false # Reduce boot times through caching; required in config/boot.rb
# gem "bootstrap", "~>5" # layout UI
# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "chronic" # for time manipulation
gem "dartsass-rails"
gem "devise" # use logins
gem "devise_masquerade" # admin can login_as
gem "factory_bot_rails" # mock objects
# gem "federails" # ActivityPub
gem "ffaker" # realistic looking test data
gem "font_awesome5_rails" # cute icon images
# gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "jquery-rails" # required for Bootstrap
gem "julia_builder" # for outputting CSV files
gem "kamal", require: false # Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
# gem "liquid" # user-editable templates
# gem "matrix" # needed for ruby 3.1+
# gem "mechanize" # for scraping web pages
# gem "mcp_rails" # agentic AI API interfaces
# gem "octokit" # query Github API
gem "plissken" # convert javascript-style names to ruby-style
gem "pg", "~> 1.1" # postgresl database
gem "puma", ">= 5.0" # a web server
# gem "que" # for running background jobs
# gem 'que-view' # for seeing what is happening with background jobs
gem "redcarpet" # use Markdown in fields
# gem "rgeo-geojson" # geo ActiveModel
gem "slack-notifier" # talk to Slack
gem "solid_cache" # database-backed adapter for Rails.cache
gem "solid_queue" # database-backed adapter for Active Job
gem "solid_cable" # database-backed adapter for Action Cable
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
# gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "wicked" # wizard controllers
gem "wikimedia-commoner", github: "jnicho02/wikimedia-commoner" # best guess famous/historical people on Wikidata
gem "will_paginate"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "rubocop-rails-omakase", require: false # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
end

group :development do
  gem "dotenv-rails", groups: :test # load ENV variables from .env
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "axe-core-rspec" # accessibility of screens
  gem "capybara" # test via web page UI
  gem "database_cleaner" # scrub down the test database between runs
  gem "rspec-rails" # specify tests
  gem "selenium-webdriver" # test via web page UI
end
