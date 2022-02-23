# frozen_string_literal: true

require 'uri'

module Trustpilot
  class Request
    attr_reader :headers, :params, :path, :verb

    # Initializes a new request to the API
    #
    # args:
    #   path: string
    #   headers: { [key: string]: string }
    #   params: { [key: string]: string }
    #   verb: 'delete' | 'get' | 'patch' | 'post' | 'put'
    def initialize path, headers: {}, params: {}, verb: 'get'
      @headers = headers
      @params = params
      @path = path
      @verb = verb
    end

    # Returns the request as a Net::HTTPRequest
    def to_http_request
      build_request.tap do |req|
        # Set headers
        headers.each { |h, v| req[ h ] = v }
      end
    end

    # Returns the full URI for the request
    def uri
      @uri ||=
        if path.start_with? 'http'
          URI path
        else
          URI( Trustpilot.api_url + path )
        end
    end

    private

    def build_request
      case verb.to_s
      when 'get'
        build_get
      when 'post'
        build_post
      else
        raise Trustpilot::Error, 'unknown request type'
      end
    end

    def build_get
      full_uri = uri.dup
      full_uri.query = URI.encode_www_form params

      Net::HTTP::Get.new full_uri.request_uri
    end

    def build_post
      req = Net::HTTP::Post.new uri.request_uri
      req.set_form_data params
      req
    end
  end
end
