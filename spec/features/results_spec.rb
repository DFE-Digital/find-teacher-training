require "rails_helper"

feature "results", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:params) {}

  before do
    stub_results_page_request
    visit results_path(params)
  end

  describe "filters defaults without query string" do
    it "has study type filter" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end
  end

  describe "filters defaults with query string" do
    let(:params) { { fulltime: "False", parttime: "False" } }

    it "has study type filter" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end
  end

  describe "filters with query string" do
    let(:params) { { fulltime: "True", parttime: "False" } }

    it "has study type filter for full time only" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter).not_to have_parttime
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end
  end

  describe "filters with query string" do
    let(:params) { { fulltime: "False", parttime: "True" } }

    it "has study type filter for part time only" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter).not_to have_fulltime
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end
  end
end
