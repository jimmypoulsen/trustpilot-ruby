# frozen_string_literal: true

require 'json'
require 'net/https'
require 'uri'

module Trustpilot
  class Api
    class << self
      # Sends a request to Trustpilot's API
      #
      # args:
      #   request: Trustpilot::Request
      def request request
        client = build_client request

        response = client.request request.to_http_request

        error = ErrorChecker.new( response ).error_if_appropriate
        raise error if error

        JSON.parse response.body
      rescue JSON::ParserError
        {}
      end

      private

      def build_client request
        # Build client
        client = Net::HTTP.new request.uri.host, 443
        client.use_ssl = true
        client.verify_mode = OpenSSL::SSL::VERIFY_PEER
        client.read_timeout = Trustpilot.api_read_timeout
        client.set_debug_output $stdout if Trustpilot.debug
        client
      end
    end
  end
end
