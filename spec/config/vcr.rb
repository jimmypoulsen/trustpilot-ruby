# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data( 'FILTERED_API_KEY' ) { Trustpilot.api_key }
  config.filter_sensitive_data( 'FILTERED_API_SECRET' ) { Trustpilot.api_secret }
  config.filter_sensitive_data( 'FILTERED_API_EMAIL' ) { Trustpilot.api_email }
  config.filter_sensitive_data( 'FILTERED_API_PASSWORD' ) { Trustpilot.api_password }
  config.filter_sensitive_data( 'FILTERED_BUSINESS_UNIT_ID' ) { Trustpilot.default_business_unit_id }
  config.filter_sensitive_data( 'FILTERED_ACCESS_TOKEN' ) { Trustpilot::Auth::Token.get }

  # Filter out Authorization headers
  config.filter_sensitive_data( 'FILTERED_AUTH_TOKEN' ) do |interaction|
    auths = interaction.request.headers[ 'Authorization' ]&.first
    auths&.split&.[]( 1 )
  end
end
