# frozen_string_literal: true

# Version
require 'trustpilot/version'

# Support classes
require 'trustpilot/api'
require 'trustpilot/api_resource'
require 'trustpilot/auth/authenticator'
require 'trustpilot/auth/token'
require 'trustpilot/error_checker'
require 'trustpilot/errors'
require 'trustpilot/request'

# Resources
require 'trustpilot/resources'

module Trustpilot
  # Default config
  @api_url = 'https://api.trustpilot.com/v1/'

  class << self
    attr_accessor :api_email, :api_password, :api_key, :api_secret, :api_read_timeout, :default_business_unit_id,
                  :debug, :redis

    attr_reader :api_url

    def with_redis &block
      raise Trustpilot::Error, 'Trustpilot.redis is not set' unless redis

      if redis.respond_to? :with
        redis.with( &block )
      else
        yield redis
      end
    end
  end
end
