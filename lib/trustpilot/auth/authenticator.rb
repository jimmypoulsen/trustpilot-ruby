# frozen_string_literal: true

require 'base64'

module Trustpilot
  module Auth
    class Authenticator
      def initialize
        return if Trustpilot.api_email && Trustpilot.api_password

        raise Trustpilot::Error, 'Trustpilot.api_email / Trustpilot.api_password are not set.'
      end

      # Gets a new access token from the API
      def request_token
        request = Request.new(
          'oauth/oauth-business-users-for-applications/accesstoken',
          headers: {
            'Authorization' => auth_header,
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          params: {
            grant_type: 'password',
            username: Trustpilot.api_email,
            password: Trustpilot.api_password
          },
          verb: 'post'
        )

        Api.request request
      end

      # Returns the value of the authentication header to use
      # when requesting an access token
      def auth_header
        unless Trustpilot.api_key && Trustpilot.api_secret
          raise Trustpilot::Error, 'Trustpilot.api_key / Trustpilot.api_secret are not set.'
        end

        "Basic #{ Base64.strict_encode64( "#{ Trustpilot.api_key }:#{ Trustpilot.api_secret }" ) }"
      end
    end
  end
end
