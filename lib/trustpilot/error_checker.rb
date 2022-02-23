# frozen_string_literal: true

module Trustpilot
  class ErrorChecker
    attr_reader :response

    # args:
    #   response: Net::HTTPResponse
    def initialize response
      @response = response
    end

    def error_if_appropriate
      if code >= 500
        init_error ServerError
      elsif code == 429
        init_error RateLimitError
      elsif code == 401
        init_error AuthenticationError
      elsif code >= 400
        init_error ClientError
      elsif code >= 300
        init_error ServerError
      end
    end

    def code
      response.code.to_i
    end

    def body
      response.body
    end

    def message
      response.message
    end

    private

    def init_error klass
      klass.new code, body, message
    end
  end
end
