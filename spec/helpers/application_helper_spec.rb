require "rails_helper"

feature "Application helpers", type: :helper do
  describe "#markdown" do
    it "converts markdown to HTML" do
      expect(helper.markdown("test")).to eq("<p class=\"govuk-body\">test</p>")
    end

    it "converts markdown lists to HTML lists" do
      expect(helper.markdown("* test\n* another test")).to include("<li>test</li>")
    end

    it "converts bullets into HTML lists" do
      output = helper.markdown("* test\n• bullet\n•bullet without space")

      expect(output).to include("<li>test</li>")
      expect(output).to include("<li>bullet</li>")
      expect(output).to include("<li>bullet without space</li>")
    end

    it "converts markdown lists into HTML when space missed between * and word" do
      output = helper.markdown("* test\n*no space here\n*also *here*")

      expect(output).to include("<li>test</li>")
      expect(output).to include("<li>no space here</li>")
      expect(output).to include("<li>also <em>here</em></li>")
    end

    it "converts quotes to smart quotes" do
      output = helper.markdown("\"Wow -- what's this...\", O'connor asked.")
      expect(output).to eq("<p class=\"govuk-body\">“Wow – what’s this…”, O’connor asked.</p>")
    end

    # Redcarpet fixes out of the box
    it "fixes incorrect markdown links" do
      output = helper.markdown("[Google] (https://www.google.com)")
      expect(output).to include("<a href=\"https://www.google.com\" class=\"govuk-link\">Google</a>")
    end
  end

  describe "#smart_quotes" do
    it "converts quotes to smart quotes" do
      output = helper.smart_quotes("\"Wow -- what's this...\", O'connor asked.")
      expect(output).to include("“Wow – what’s this…”, O’connor asked.")
    end
  end
end
