require "rails_helper"

module ResultFilters
  describe LocationFilterForm do
    before do
      stub_geocoder
    end

    describe "Validation" do
      subject { described_class.new(params) }
      context "no option selected" do
        let(:params) { {} }
        it "is not valid" do
          expect(subject.valid?).to eq(false)
        end

        it "has error" do
          subject.valid?
          expect(subject.errors).to eq(["Please choose an option"])
        end

        it "has empty params" do
          subject.valid?
          expect(subject.params).to be_empty
        end
      end

      context "unknown location" do
        let(:params) { { l: "1", lq: "Unknown location" } }

        it "is not valid" do
          expect(subject.valid?).to eq(false)
        end

        it "has error" do
          subject.valid?
          expect(subject.errors).to eq(["Postcode, town or city", "We couldn't find this location, please check your input and try again"])
        end

        it "has params" do
          subject.valid?
          expect(subject.params).to eq(params)
        end
      end

      context "known location" do
        let(:params) { { l: "1", lq: "SW1P 3BT" } }

        it "is not valid" do
          expect(subject.valid?).to eq(true)
        end

        it "has no errors" do
          subject.valid?
          expect(subject.errors).to be_empty
        end

        it "has params" do
          subject.valid?
          expect(subject.params).to eq(params)
        end
      end
    end
  end
end
