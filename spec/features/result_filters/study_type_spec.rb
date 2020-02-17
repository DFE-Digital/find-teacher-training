require "rails_helper"

feature "Study type filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::StudyType.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  let(:base_parameters) do
    {
      "filter[vacancies]" => "true",
      "include" => "provider",
      "page[page]" => 1,
      "page[per_page]" => 10,
    }
  end

  before do
    stub_api_v3_resource(
      type: SubjectArea,
      resources: nil,
      include: [:subjects],
        )
  end

  describe "viewing results without explicitly selecting a filter" do
    before do
      stub_request(:get, url)
        .with(query: base_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    it "lists only courses with both study types" do
      results_page.load

      expect(results_page.study_type_filter).to have_parttime
      expect(results_page.study_type_filter).to have_fulltime

      expect(results_page.courses.count).to eq(2)
    end
  end

  describe "applying a filter" do
    before do
      stub_request(:get, url)
        .with(query: base_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/empty_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    context "deselecting full time" do
      before do
        stub_request(:get, url)
          .with(query: base_parameters.merge("filter[study_type]" => "part_time"))
          .to_return(
            body: File.new("spec/fixtures/api_responses/courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

      it "list the courses" do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq("Study type")
        filter_page.full_time.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq("Teacher training courses")
        expect(results_page.study_type_filter).to have_parttime

        expect(results_page.courses.count).to eq(2)
      end
    end

    context "deselecting part time" do
      before do
        stub_request(:get, url)
          .with(query: base_parameters.merge("filter[study_type]" => "full_time"))
          .to_return(
            body: File.new("spec/fixtures/api_responses/courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

      it "list the courses" do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq("Study type")
        filter_page.part_time.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq("Teacher training courses")
        expect(results_page.study_type_filter).to have_fulltime

        expect(results_page.courses.count).to eq(2)
      end
    end

    context "deselecting full time and part time" do
      it "displays an error" do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq("Study type")
        filter_page.part_time.click
        filter_page.full_time.click
        filter_page.find_courses.click

        expect(filter_page).to have_error
      end
    end

    context "submitting without deselection" do
      before do
        stub_request(:get, url)
          .with(query: base_parameters.merge("filter[study_type]" => "full_time,part_time"))
          .to_return(
            body: File.new("spec/fixtures/api_responses/courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

      it "list the courses" do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq("Study type")

        filter_page.find_courses.click

        expect(filter_page.heading.text).to eq("Teacher training courses")

        expect(results_page.study_type_filter).to have_fulltime

        expect(results_page.study_type_filter).to have_parttime

        expect(results_page.courses.count).to eq(2)
      end
    end
  end
end

#   before do
#     stub_results_page_request
#   end
#
#   describe "back link" do
#     it "navigates back to the results page" do
#       filter_page.load(query: { test: "params" })
#       filter_page.back_link.click
#
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params:  {
#           "fulltime" => "False",
#           "hasvacancies" => "True",
#           "parttime" => "False",
#           "qualifications" => "QtsOnly,PgdePgceWithQts,Other",
#           "senCourses" => "False",
#           "test" => "params",
#         },
#       )
#     end
#   end
#
#
#   describe "deselecting an option" do
#     before { filter_page.load }
#
#     it "default full time and part time to true" do
#       expect(filter_page.full_time.checked?).to be true
#       expect(filter_page.part_time.checked?).to be true
#     end
#
#     it "Allows the user to deselect full time" do
#       filter_page.full_time.click
#       filter_page.find_courses.click
#
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params: {
#           "fulltime" => "False",
#           "parttime" => "True",
#         },
#       )
#     end
#
#     it "Allows the user to deselect part time" do
#       filter_page.part_time.click
#       filter_page.find_courses.click
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params: {
#           "fulltime" => "True",
#           "parttime" => "False",
#         },
#       )
#     end
#
#     it "Allows the user to find courses" do
#       filter_page.find_courses.click
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params: {
#           "fulltime" => "True",
#           "parttime" => "True",
#         },
#       )
#     end
#   end
#
#   describe "Navigating to the page with currently selected filters" do
#     it "Allows the full time param to be pre-selected" do
#       filter_page.load(query: { fulltime: "True" })
#       expect(filter_page.full_time.checked?).to eq(true)
#     end
#
#     it "Allows the part time param to be pre-selected" do
#       filter_page.load(query: { parttime: "True" })
#       expect(filter_page.part_time.checked?).to eq(true)
#     end
#   end
#
#   describe "Validation" do
#     it "Displays an error if neither option is selected" do
#       filter_page.load
#
#       filter_page.part_time.click
#       filter_page.full_time.click
#
#       filter_page.find_courses.click
#
#       expect(filter_page).to have_error
#     end
#   end
#
#   describe "QS parameters" do
#     it "passes querystring parameters to results" do
#       filter_page.load(query: { test: "value", parttime: "True" })
#
#       filter_page.find_courses.click
#
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params: {
#           "fulltime" => "False",
#           "parttime" => "True",
#           "test" => "value",
#         },
#       )
#     end
#
#     it "passes arrays correctly" do
#       url_with_array_params = "#{filter_page.url}?test[]=1&test[]=2"
#       PageObjects::Page::ResultFilters::StudyType.set_url(url_with_array_params)
#
#       filter_page.load
#       filter_page.part_time.click
#       filter_page.find_courses.click
#
#       expect(results_page).to be_displayed
#
#       expect_page_to_be_displayed_with_query(
#         page: results_page,
#         expected_query_params: {
#           "fulltime" => "True",
#           "parttime" => "False",
#           "test" => "1,2",
#         },
#       )
#     end
#   end
# end
