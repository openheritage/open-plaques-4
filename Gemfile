source "https://rubygems.org"

ruby "3.3.4"
gem "rails", ">= 8.0"
# gem "rails", github: "rails/rails", branch: "main" # edge Rails

gem "aasm" # manage object state
# gem "activerecord-postgis-adapter" # link to Postgis geo database
gem "activestorage-validator" # Validate file types saved in Active Storage
# gem 'active_record_extended' # adds Postgres-specific methods to ActiveRecord
gem "acts-as-taggable-on", github: "mbleigh/acts-as-taggable-on", branch: :master # taggable contexts
gem "aws-sdk-comprehend"
gem "aws-sdk-s3", require: false
gem "aws-sdk-translate"
# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bootsnap", require: false # Reduce boot times through caching; required in config/boot.rb
gem "bootstrap" # Styling for UI elements
# gem "chronic" # for time manipulation
# gem "csv" # read and write CSV files
# gem "csvreader" # parse CSVs reliably
gem "dartsass-rails" # Dynamic stylesheet rules
gem "devise" # User logins and authentication
gem "devise_masquerade" # admin can login_as
gem "factory_bot_rails" # mock objects
# gem "fast-mcp" # resources and tools for AI agents
# gem "federails" # ActivityPub
gem "ffaker" # realistic looking test data
gem "font_awesome5_rails" # cute icon images
# gem "get_process_mem" # for knowing how much memory is being used
# gem "graphql-client" # talk to Monday.com
# gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jquery-rails" # required for Bootstrap
gem "julia_builder" # for outputting CSV files
# gem "kamal", require: false # Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
# gem "liquid" # user-editable templates
# gem "matrix" # needed for ruby 3.1+
gem "meta-tags"
gem "nokogiri" # parse html
# gem "pagy" # for fast-working record pagination
gem "omniauth-google-oauth2" # authenticate with Google
gem "omniauth-rails_csrf_protection" # include valid CSRF tokens with OAuth requests
gem "pg", "~> 1.6" # postgresl database
gem "plissken" # convert javascript-style names to ruby-style
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "puma", ">= 5.0" # a web server
# gem "que" # for running background jobs
# gem "que-view" # for seeing what is happening with background jobs
gem "redcarpet" # use Markdown in fields
gem "rexml" # process XML
# gem "rgeo-geojson" # geo ActiveModel
# gem "ruby_llm" # talk to a variety of LLMs
gem "sanitize" # for cleaning up html fragments
gem "slack-notifier" # talk to Slack
gem "solid_cable" # database-backed adapter for Action Cable
gem "solid_cache" # database-backed adapter for Rails.cache
gem "solid_queue" # database-backed adapter for Active Job
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "wicked" # wizard controllers
gem "wikimedia-commoner", github: "jnicho02/wikimedia-commoner" # best guess famous/historical people on Wikidata
gem "will_paginate" # paginate long lists of data

group :development, :test do
  gem "brakeman", require: false # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
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

gem "dockerfile-rails", ">= 1.7", group: :development
