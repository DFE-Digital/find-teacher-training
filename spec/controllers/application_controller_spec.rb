require 'rails_helper'

describe ApplicationController do
  let(:request_uuid) { SecureRandom.uuid }

  before do
    allow(request).to receive(:uuid).and_return(request_uuid)
  end

  describe '#store_request_id' do
    it 'stores the request id' do
      allow(RequestStore).to receive(:store).and_return({})

      controller.__send__(:store_request_id)

      expect(RequestStore.store).to eq(request_id: request_uuid)
    end
  end

  describe '#assign_sentry_contexts' do
    it 'assigns a request id to Sentry tags' do
      allow(Sentry).to receive(:set_tags).and_return({})
      controller.__send__(:store_request_id)
      controller.__send__(:assign_sentry_contexts)
      expect(Sentry).to have_received(:set_tags).with(request_id: request_uuid)
    end
  end

  describe '#append_info_to_payload' do
    it 'sets the request_id in the payload to the request uuid' do
      payload = {}

      allow(RequestStore).to receive(:store).and_return(request_id: request_uuid)

      controller.__send__(:append_info_to_payload, payload)

      expect(payload[:request_id]).to eq request_uuid
    end
  end
end
