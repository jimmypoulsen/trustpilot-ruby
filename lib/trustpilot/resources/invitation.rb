# frozen_string_literal: true

module Trustpilot
  class Invitation < ApiResource
    attr_reader :business_unit_id

    def initialize business_unit_id = nil
      super()

      @business_unit_id = business_unit_id || Trustpilot.default_business_unit_id
    end

    # Generate a unique invitation link that can be sent to a consumer by email or website.
    # https://developers.trustpilot.com/invitation-api#generate-service-review-invitation-link
    def service_review_link params
      request(
        "https://invitations-api.trustpilot.com/v1/private/business-units/#{ business_unit_id }/invitation-links",
        auth_method: :oauth,
        params: params,
        verb: 'post'
      )
    end
  end
end
