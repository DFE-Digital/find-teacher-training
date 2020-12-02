require 'rails_helper'

describe SiteDecorator do
  let(:site) do
    build(:site, address1: '1 Sample Road', postcode: 'W1 ABC')
  end

  let(:decorated_site) { site.decorate }

  it 'returns the full address' do
    expect(decorated_site.full_address).to eq('1 Sample Road, W1 ABC')
  end
end
