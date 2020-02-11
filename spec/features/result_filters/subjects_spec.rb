require "rails_helper"

feature "Subject filter", type: :feature do
  let(:subject_filter_page) { PageObjects::Page::ResultFilters::SubjectPage.new }
  let(:results_page) { PageObjects::Page::Results.new }

  let(:subject_areas) do
    [
      build(:subject_area, subjects: [
        build(:subject, :primary, id: 1, bursary_amount: "1000"),
        build(:subject, :biology, id: 10, scholarship: "2000", subject_knowledge_enhancement_course_available: true),
        build(:subject, :russian, id: 38, bursary_amount: "3000", scholarship: "4000", early_career_payments: "1000"),
        ]),
      build(:subject_area, :secondary, subjects: [build(:subject, :english, id: 12, subject_knowledge_enhancement_course_available: true)]),
    ]
  end

  before do
    stub_results_page_request

    stub_api_v3_resource(
      type: SubjectArea,
      resources: subject_areas,
      include: [:subjects],
    )

    subject_filter_page.load
  end

  describe "back link" do
    it "navigates back to the results page" do
      subject_filter_page.load(query: { test: "params" })
      subject_filter_page.back_link.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params:  {
          "fulltime" => "False",
          "hasvacancies" => "True",
          "parttime" => "False",
          "qualifications" => "QtsOnly,PgdePgceWithQts,Other",
          "senCourses" => "False",
          "test" => "params",
        },
      )
    end
  end

  context "check each accordion section" do
    it "has aria-control set to the section-content id" do
      subject_filter_page.subject_areas.each_with_index do |accordion_section, counter|
        subject_area_name = subject_areas[counter].typename.downcase
        control_id = "#{subject_area_name}-content-#{counter}"
        section_button = accordion_section.find(".govuk-accordion__section-button")

        expect(section_button["aria-controls"]).to eq(control_id)
        expect(accordion_section).to have_selector("div##{control_id}")
      end

      # Check SEND section
      expect(subject_filter_page.send_area.accordion_button["aria-controls"]).to eq("send-content")
      expect(subject_filter_page.send_area).to have_selector("div#send-content")
    end
  end

  context "on the start page" do
    it "has a back link to the root page" do
      visit start_subject_path
      subject_filter_page.back_link.click
      expect(URI(current_url).path).to eq("/")
    end

    it "the submit button displays 'Continue'" do
      visit start_subject_path
      expect(subject_filter_page.continue.value).to eq("Continue")
    end
  end

  context "with no selected subjects" do
    let(:expected_financial_info) do
      [
        "Scholarships of £2,000 are available.",
        "Bursaries of £1,000 available.",
        "Scholarships of £4,000 and bursaries of £3,000 are available, with early career payments of £2,000 each in your second, third and fourth year of teaching (£3,000 in some areas of England).",
        "",
      ]
    end

    it "should set assistive technology attributes appropriately" do
      expect(subject_filter_page.subject_areas.first.accordion_button).to match_selector('[aria-expanded="false"]')
      expect(subject_filter_page.send_area.accordion_button).to match_selector('[aria-expanded="false"]')
    end

    it "should not expand any accordion sections" do
      expect(subject_filter_page.subject_areas.first).to have_no_css(".govuk-accordion__section--expanded")
      expect(subject_filter_page.send_area).to have_no_css(".govuk-accordion__section--expanded")
    end

    it "displays all subject areas" do
      subject_filter_page.subject_areas.first.then do |subject_area|
        expect(subject_area.name.text).to eq("Primary")
      end

      subject_filter_page.subject_areas.second.then do |subject_area|
        expect(subject_area.name.text).to eq("Secondary")
      end
    end

    it "displays all subjects with financial information" do
      subject_filter_page.subject_areas.first.then do |subject_area|
        subject_area.subjects.first.then do |subject|
          expect(subject.name.text).to eq(subject_areas.first.subjects.second.subject_name)
          expect(subject.info.text).to eq(expected_financial_info[0])
          expect(subject.ske_course.text).to eq("You can also take a subject knowledge enhancement (SKE) course.")
        end
        subject_area.subjects.second.then do |subject|
          expect(subject.name.text).to eq(subject_areas.first.subjects.first.subject_name)
          expect(subject.info.text).to eq(expected_financial_info[1])
          expect(subject).not_to have_ske_course
        end
        subject_area.subjects.third.then do |subject|
          expect(subject.name.text).to eq(subject_areas.first.subjects.third.subject_name)
          expect(subject.info.text).to eq(expected_financial_info[2])
          expect(subject).not_to have_ske_course
        end
      end
      subject_filter_page.subject_areas.second.then do |subject_area|
        subject_area.subjects.first.then do |subject|
          expect(subject.name.text).to eq(subject_areas.second.subjects.first.subject_name)
          expect(subject.info.text).to eq(expected_financial_info[3])
          expect(subject.ske_course.text).to eq("You can take a subject knowledge enhancement (SKE) course.")
        end
      end
      subject_filter_page.send_area.then do |subject_area|
        subject_area.subjects.first.then do |subject|
          expect(subject.name.text).to eq("Show only courses with a SEND specialism")
        end
      end
    end

    it "can select a checkbox and filter appropriately" do
      subject_filter_page.subject_areas.first.subjects.first.checkbox.click
      subject_filter_page.continue.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "subjects" => "1",
        },
      )
    end

    it "can select multiple checkboxes and filter appropriately" do
      subject_filter_page.subject_areas.first.subjects.first.checkbox.click
      subject_filter_page.subject_areas.first.subjects.second.checkbox.click
      subject_filter_page.send_area.subjects.first.checkbox.click
      subject_filter_page.continue.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "subjects" => "1,31",
          "senCourses" => "true",
        },
      )
    end
  end

  context "with previously selected subjects" do
    it "automatically selects the given checkboxes" do
      subject_filter_page.load(query: { subjects: "1", senCourses: "true" })
      expect(subject_filter_page.subject_areas.first.subjects.first.checkbox).to be_checked
      expect(subject_filter_page.send_area.subjects.first.checkbox).to be_checked
    end

    it "automatically selects the given checkboxes with C# casing" do
      subject_filter_page.load(query: { senCourses: "True" })
      expect(subject_filter_page.send_area.subjects.first.checkbox).to be_checked
    end
  end

  context "with existing parameters" do
    it "only changes the subjects params" do
      subject_filter_page.load(query: { subjects: "1,31", other_param: "param_value" })
      subject_filter_page.continue.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "subjects" => "1,31",
          "other_param" => "param_value",
        },
      )
    end

    it "should set assistive technology attributes appropriately" do
      subject_filter_page.load(query: { subjects: "1,31", other_param: "param_value", senCourses: "True" })
      expect(subject_filter_page.subject_areas.first.accordion_button).to match_selector('[aria-expanded="true"]')
      expect(subject_filter_page.send_area.accordion_button).to match_selector('[aria-expanded="true"]')
    end

    it "should expand any appropriate accordion sections" do
      subject_filter_page.load(query: { subjects: "1,31", other_param: "param_value", senCourses: "True" })
      expect(subject_filter_page.subject_areas.first.root_element).to match_selector(".govuk-accordion__section--expanded")
      expect(subject_filter_page.subject_areas.second.root_element).not_to match_selector(".govuk-accordion__section--expanded")
      expect(subject_filter_page.send_area.root_element).to match_selector(".govuk-accordion__section--expanded")
    end
  end

  context "with the modern languages subject" do
    let(:subject_areas) do
      [
        build(:subject_area, subjects: [build(:subject, :modern_languages)]),
      ]
    end

    it "excludes the modern languages subject" do
      expect(subject_filter_page.subject_areas.first.subjects.length).to eq(0)
    end
  end
end
