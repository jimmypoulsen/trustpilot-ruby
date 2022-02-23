# frozen_string_literal: true

require 'bundler/setup'
require 'trustpilot'

# Gems
require 'mock_redis'
require 'webmock/rspec'

# Config files
require 'config/vcr'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Config setup for testing
  settings_file_name = 'spec/settings.yml'
  raise 'spec/settings.yml must be set up before running the test suite.' unless File.exist? settings_file_name

  settings = YAML.safe_load ERB.new( File.read( settings_file_name )).result

  Trustpilot.api_key = settings[ 'api_key' ]
  Trustpilot.api_secret = settings[ 'api_secret' ]
  Trustpilot.api_email = settings[ 'api_email' ]
  Trustpilot.api_password = settings[ 'api_password' ]
  Trustpilot.default_business_unit_id = settings[ 'default_business_unit_id' ]
  Trustpilot.redis = MockRedis.new
end
