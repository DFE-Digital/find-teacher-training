require "rails_helper"

describe ProviderDecorator do
  let(:provider) do
    build(:provider,
          accredited_body?: false,
          website: "www.acmescitt.com",
          address1: "1 Sample Road",
          postcode: "W1 ABC")
  end

  let(:decorated_provider) { provider.decorate }

  it "returns a valid website URL" do
    expect(decorated_provider.website).to eq("http://www.acmescitt.com")
  end

  it "returns the full address" do
    expect(decorated_provider.full_address).to eq("1 Sample Road<br> W1 ABC")
  end
end
