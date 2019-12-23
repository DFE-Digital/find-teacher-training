require "rails_helper"

feature "View helpers", type: :helper do
  describe "#govuk_link_to" do
    it "returns an anchor tag with the govuk-link class" do
      expect(helper.govuk_link_to("ACME SCITT", "https://localhost:3000/organisations/A0")).to eq("<a class=\"govuk-link\" href=\"https://localhost:3000/organisations/A0\">ACME SCITT</a>")
    end
  end
end
