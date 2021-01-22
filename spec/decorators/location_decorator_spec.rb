require 'rails_helper'

describe LocationDecorator do
  let(:location) do
    build(:location, street_address_1: '1 Sample Road', postcode: 'W1 ABC')
  end

  let(:decorated_location) { location.decorate }

  it 'returns the full address' do
    expect(decorated_location.full_address).to eq('1 Sample Road, W1 ABC')
  end
end
