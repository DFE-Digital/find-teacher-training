require 'rails_helper'

describe ProviderDecorator do
  let(:provider) do
    build(
      :provider,
      accredited_body?: false,
      website: 'www.acmescitt.com',
      address1: '1 Sample Road',
      postcode: 'W1 ABC',
    )
  end

  let(:decorated_provider) { provider.decorate }

  describe '#website' do
    subject { decorated_provider.website }

    context 'with website' do
      it { is_expected.to eq('http://www.acmescitt.com') }
    end

    context 'without website' do
      let(:provider) { build(:provider, website: nil) }

      it { is_expected.to eq(nil) }
    end
  end

  it 'returns the full address' do
    expect(decorated_provider.full_address).to eq('1 Sample Road<br> W1 ABC')
  end

  describe '#short_address' do
    context 'with a full address' do
      let(:provider) do
        build(
          :provider,
          accredited_body?: false,
          website: 'www.acmescitt.com',
          address1: 'Building 64',
          address2: '32 Copton Lane',
          address3: 'Bracknel',
          address4: 'Berkshire',
          postcode: 'NXT STP',
        )
      end

      it 'returns a complete address' do
        expect(decorated_provider.short_address).to eq('Building 64, 32 Copton Lane, Bracknel, Berkshire, NXT STP')
      end
    end

    context 'with a partial address' do
      let(:provider) do
        build(
          :provider,
          accredited_body?: false,
          website: 'www.acmescitt.com',
          address1: 'Building 64',
          address2: '32 Copton Lane',
          postcode: 'NXT STP',
        )
      end

      it 'returns a partial address' do
        expect(decorated_provider.short_address).to eq('Building 64, 32 Copton Lane, NXT STP')
      end
    end
  end
end
