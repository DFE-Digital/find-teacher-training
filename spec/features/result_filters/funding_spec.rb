require "rails_helper"

feature "Funding filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Funding.new }
  let(:results_page) { PageObjects::Page::Results.new }

  let(:salary_course_param_value_from_c_sharp) { "8" }
  let(:all_course_param_value_from_c_sharp) { "15" }

  describe "funding page" do
    before { filter_page.load }

    it "has the correct title and heading" do
      expect(page.title).to have_content("Find courses that pay a salary")
      expect(page).to have_content("Find courses that pay a salary")
    end

    describe "back link" do
      before do
        stub_results_page_request
      end

      it "navigates back to the results page" do
        filter_page.load(query: { test: "params" })
        filter_page.back_link.click

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: { "test" => "params" },
        )
      end
    end

    describe "selecting an option" do
      before do
        stub_results_page_request
      end

      let(:qs_params) { "one=two" }

      it "allows the user to select all courses" do
        filter_page.all_courses.click
        filter_page.find_courses.click

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: { "funding" => all_course_param_value_from_c_sharp },
        )
      end

      it "allows the user to select salary courses" do
        filter_page.salary_courses.click
        filter_page.find_courses.click

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: { "funding" => salary_course_param_value_from_c_sharp },
        )
      end
    end

    describe "Pre populated value" do
      context "with no salary_filter parameter" do
        it "the all_courses button is selected by default" do
          expect(filter_page.all_courses).to be_checked
          expect(filter_page.salary_courses).not_to be_checked
        end
      end

      context "with the salary filter set to salary courses only" do
        before { filter_page.load(query: { "funding" => salary_course_param_value_from_c_sharp }) }

        it "the salary_course button is selected" do
          expect(filter_page.salary_courses).to be_checked
          expect(filter_page.all_courses).not_to be_checked
        end
      end

      context "with the salary filter set to all courses" do
        before { filter_page.load(query: { "funding" => all_course_param_value_from_c_sharp }) }

        it "the salary_course button is selected" do
          expect(filter_page.salary_courses).not_to be_checked
          expect(filter_page.all_courses).to be_checked
        end
      end
    end

    describe "QS parameters" do
      before do
        stub_results_page_request
      end

      it "passes querystring parameters to results" do
        filter_page.load(query: { test: "value" })
        filter_page.all_courses.click
        filter_page.find_courses.click

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            "funding" => all_course_param_value_from_c_sharp,
            "test" => "value",
          },
        )
      end

      it "passes arrays correctly" do
        url_with_array_params = "#{filter_page.url}?test=1,2"
        PageObjects::Page::ResultFilters::Funding.set_url(url_with_array_params)

        filter_page.load
        filter_page.all_courses.click
        filter_page.find_courses.click

        expect(results_page).to be_displayed

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            "funding" => all_course_param_value_from_c_sharp,
            "test" => "1,2",
          },
        )
      end
    end
  end
end
