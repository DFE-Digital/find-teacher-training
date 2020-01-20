require "rails_helper"

feature "View helpers", type: :helper do
  describe "#govuk_link_to" do
    it "returns an anchor tag with the govuk-link class" do
      expect(helper.govuk_link_to("ACME SCITT", "https://localhost:3000/organisations/A0")).to eq("<a class=\"govuk-link\" href=\"https://localhost:3000/organisations/A0\">ACME SCITT</a>")
    end
  end

  describe "#govuk_back_link_to" do
    it "renders a link to the provided URL" do
      expect(helper.govuk_back_link_to("https://localhost:3000/organisations/A0"))
        .to eq("<a class=\"govuk-back-link\" data-qa=\"page-back\" href=\"https://localhost:3000/organisations/A0\">Back</a>")
    end

    context "when passed alternative link text" do
      it "renders the text in the link" do
        expect(helper.govuk_back_link_to("https://localhost:3000/organisations/A0", "Booyah"))
          .to eq("<a class=\"govuk-back-link\" data-qa=\"page-back\" href=\"https://localhost:3000/organisations/A0\">Booyah</a>")
      end
    end
  end
end
