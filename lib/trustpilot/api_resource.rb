# frozen_string_literal: true

module Trustpilot
  class ApiResource
    MUTEX = Mutex.new

    # Sends a request to the API
    #
    # This method will take care of authentication before calling the API, requesting
    # a new access token if necessary.
    #
    # args:
    #   path: string
    #   auth_method: 'oauth' | 'key'
    #   params: { [key: string]: string }
    #   verb: 'delete', 'get', 'patch', 'post', 'put'
    def request path, auth_method:, params: {}, body: {}, verb: 'get'
      is_oauth = auth_method.to_s == 'oauth'

      MUTEX.synchronize do
        renew_token if is_oauth && Auth::Token.expired?

        call_api path, verb, auth_method, params, body
      rescue AuthenticationError
        # Invalid token/session, try again
        renew_token
        call_api path, verb, auth_method, params, body
      end
    end

    private

    def call_api path, verb, auth_method, params, body
      request = Request.new path, headers: auth_headers( auth_method ), params: params, body: body, verb: verb

      Api.request request
    end

    def auth_headers auth_method
      case auth_method.to_s
      when 'oauth'
        { 'Authorization' => "Bearer #{ Auth::Token.get }" }
      when 'key'
        { 'apikey' => Trustpilot.api_key }
      else
        raise Trustpilot::Error, 'unknown authentication type'
      end
    end

    def renew_token
      response = Auth::Authenticator.new.request_token

      Auth::Token.set response[ 'access_token' ], ( Time.now + response[ 'expires_in' ].to_i )
    end
  end
end
