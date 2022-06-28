# frozen_string_literal: true

RSpec.describe Trustpilot::Invitation, mock_redis: true do
  subject( :resource ) { described_class.new }

  describe '#service_review_link' do
    it 'generates a new service review request link' do
      params = {
        locationId: 'ABC123',
        referenceId: 'inv00001',
        email: 'federico@goldbelly.com',
        name: 'Fede',
        locale: 'en-US',
        tags: %w[
          tag1
          tag2
        ],
        redirectUri: 'https://goldbelly.com'
      }

      VCR.use_cassette 'invitation/service_review_link_success' do
        response = resource.service_review_link params

        expect( response ).to eq(
          'id' => '81be73226625b8b765a020c20beb0f41',
          'url' => 'https://www.trustpilot.com/evaluate-link/81be73226625b8b765a020c20beb0f41'
        )
      end
    end
  end

  describe '#email' do
    it 'sends an email' do
      body = {
        "replyTo": "jp@legalhero.dk",
        "locale": "en-US",
        "senderName": "Legalhero Tp Testing",
        "senderEmail": "noreply.invitations@trustpilotmail.com",
        "locationId": "ABC123",
        "referenceNumber": "inv00001",
        "consumerName": "Jimmy Poulsen",
        "consumerEmail": "jp@legalhero.dk",
        "phoneNumber": "+4531337135",
        "type": "email",
        "serviceReviewInvitation": {
          "templateId": "627b86cc1636b8217b0cdb82",
          "redirectUri": "http://trustpilot.com",
          "tags": [
            "tag1",
            "tag2"
          ]
        }
      }.to_s

      VCR.use_cassette 'invitation/email_success' do
        response = resource.email body

        expect( response ).to eq(
          'id' => '81be73226625b8b765a020c20beb0f41',
          'url' => 'https://www.trustpilot.com/evaluate-link/81be73226625b8b765a020c20beb0f41'
        )
      end
    end
  end
end
