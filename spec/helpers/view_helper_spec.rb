require 'rails_helper'

describe 'View helpers', type: :helper do
  describe '#permitted_referrer?' do
    context 'With a blank referrer' do
      it 'Returns false' do
        expect(helper.permitted_referrer?).to be(false)
      end
    end

    context 'With a referrer from the current application' do
      it 'returns true' do
        headers = { "HTTP_REFERER": helper.request.host_with_port }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to be(true)
      end

      it 'returns true with protocol on the start' do
        headers = { "HTTP_REFERER": "http://#{helper.request.host_with_port}" }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to be(true)
      end
    end

    context 'with any other valid referrer' do
      it 'returns true' do
        headers = { "HTTP_REFERER": 'http://localhost:9000' }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to be(true)
      end
    end
  end
end
