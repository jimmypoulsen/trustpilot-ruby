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
end
