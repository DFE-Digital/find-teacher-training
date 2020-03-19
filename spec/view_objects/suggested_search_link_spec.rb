require "rails_helper"

describe SuggestedSearchLink do
  context "radius is nil" do
    let(:parameters) { { "lat" => "5", "lng" => "-5", "rad" => "10", "loc" => "Shetlands", "lq" => "2" } }
    subject { described_class.new(radius: nil, count: "5", parameters: parameters) }

    describe "#text" do
      subject { super().text }
      it { is_expected.to eq("5 courses across England") }
    end

    describe "#url" do
      subject { super().url }
      it { is_expected.to eq("/results?l=2") }
    end
  end

  context "radius is 10" do
    let(:parameters) { { "lat" => "5", "lng" => "-5", "rad" => "5", "loc" => "Shetlands", "lq" => "2" } }
    subject { described_class.new(radius: "10", count: "5", parameters: parameters) }

    describe "#text" do
      subject { super().text }
      it { is_expected.to eq("5 courses within 10 miles") }
    end

    describe "#url" do
      it "produces the correct URL" do
        uri = URI(subject.url)
        expect(uri.path).to eq("/results")
        expect(Rack::Utils.parse_nested_query(uri.query)).to eq({
          "lat" => "5",
          "lng" => "-5",
          "rad" => "10",
          "loc" => "Shetlands",
          "lq" => "2",
        })
      end
    end
  end
end
