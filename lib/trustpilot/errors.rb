# frozen_string_literal: true

module Trustpilot
  class Error < StandardError; end

  class APIError < ::Trustpilot::Error
    attr_reader :http_status, :body, :message

    def initialize http_status, body, message = nil
      super()

      @http_status = http_status
      @body = body
      @message = message
    end
  end

  # An error while attempting to request an access token
  class OAuthTokenRequestError < APIError; end

  # API rate limit
  class RateLimitError < APIError; end

  # Any error with a 5xx HTTP status code
  class ServerError < APIError; end

  # Any error with a 4xx HTTP status code
  class ClientError < APIError; end

  # All API authentication failures
  class AuthenticationError < ClientError; end
end
