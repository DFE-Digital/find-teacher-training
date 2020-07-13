require_relative "../../app/services/deprecated_parameters_service.rb"

describe DeprecatedParametersService do
  subject { described_class.call(parameters: parameters) }
  let(:parameters) do
    {}
  end
  context "Empty parameters" do
    it "should return false for deprecated" do
      expect(subject[:deprecated]).to be(false)
    end
    it "should return empty parameters" do
      expect(subject[:parameters]).to be_empty
    end
  end
  context "With parameters" do
    let(:parameters) do
      {
        "rad" => "20",
      }
    end
    it "should return true for deprecated" do
      expect(subject[:deprecated]).to be(true)
    end

    it "should return 50" do
      expect(subject[:parameters]).to eq("rad" => "50")
    end
  end
end
