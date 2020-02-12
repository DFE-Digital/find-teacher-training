require "rails_helper"

describe SubjectDecorator do
  let(:subject_with_scholarship) { build(:subject, :mathematics, scholarship: "2000") }
  let(:subject_with_bursary) { build(:subject, :biology, bursary_amount: "26000") }
  let(:subject_with_scholarship_and_bursary) { build(:subject, :biology, scholarship: "10000", bursary_amount: "5000") }
  let(:subject_with_early_career_payments) do
    build(:subject,
          :french,
          scholarship: "10000",
          bursary_amount: "5000",
          early_career_payments: "1000")
  end

  context "financial information" do
    describe "#has_scholarship?" do
      it "returns true if the subject has a scholarship" do
        expect(subject_with_scholarship.decorate.has_scholarship?).to be true
      end

      it "returns false if the subject doesn't have a scholarship" do
        expect(subject_with_bursary.decorate.has_scholarship?).to be false
      end
    end

    describe "#has_bursary?" do
      it "returns true if the subject has a bursary" do
        expect(subject_with_bursary.decorate.has_bursary?).to be true
      end

      it "returns false if the subject doesn't have a bursary" do
        expect(subject_with_scholarship.decorate.has_bursary?).to be false
      end
    end

    describe "#has_scholarship_and_bursary?" do
      it "returns true if the subject has a scholarship and a bursary" do
        expect(subject_with_scholarship_and_bursary.decorate.has_scholarship_and_bursary?).to be true
      end

      it "returns false if the subject have both scholarship and bursary" do
        expect(subject_with_scholarship.decorate.has_scholarship_and_bursary?).to be false
      end
    end

    describe "#early_career_payments?" do
      it "returns true if early career payments are available" do
        expect(subject_with_early_career_payments.decorate.early_career_payments?).to be true
      end

      it "returns false if early career payments are not available" do
        expect(subject_with_scholarship.decorate.early_career_payments?).to be false
      end
    end
  end
end
