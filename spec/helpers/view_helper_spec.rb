require 'rails_helper'

describe 'View helpers', type: :helper do
  describe '#govuk_link_to' do
    it 'returns an anchor tag with the govuk-link class' do
      expect(helper.govuk_link_to('ACME SCITT', 'https://localhost:3000/organisations/A0')).to eq('<a class="govuk-link" href="https://localhost:3000/organisations/A0">ACME SCITT</a>')
    end
  end

  describe '#govuk_back_link_to' do
    it 'renders a link to the provided URL' do
      expect(helper.govuk_back_link_to('https://localhost:3000/organisations/A0'))
        .to eq('<a class="govuk-back-link" data-qa="page-back" href="https://localhost:3000/organisations/A0">Back</a>')
    end

    context 'when passed alternative link text' do
      it 'renders the text in the link' do
        expect(helper.govuk_back_link_to('https://localhost:3000/organisations/A0', 'Booyah'))
          .to eq('<a class="govuk-back-link" data-qa="page-back" href="https://localhost:3000/organisations/A0">Booyah</a>')
      end
    end
  end

  describe '#permitted_referrer?' do
    context 'With a blank referrer' do
      it 'Returns false' do
        expect(helper.permitted_referrer?).to eq(false)
      end
    end

    context 'With a referrer from the current application' do
      it 'returns true' do
        headers = { "HTTP_REFERER": helper.request.host_with_port }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to eq(true)
      end

      it 'returns true with protocol on the start' do
        headers = { "HTTP_REFERER": "http://#{helper.request.host_with_port}" }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to eq(true)
      end
    end

    context 'with any other valid referrer' do
      it 'returns true' do
        headers = { "HTTP_REFERER": 'http://localhost:9000' }
        helper.request.headers.merge!(headers)
        expect(helper.permitted_referrer?).to eq(true)
      end
    end
  end
end
