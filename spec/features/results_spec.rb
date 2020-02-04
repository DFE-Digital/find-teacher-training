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

    it "has vacancies filter" do
      expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
      expect(results_page.vacancies_filter.vacancies).to have_content("Only courses with vacancies")
      expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
    end
  end

  describe "filters defaults with query string" do
    let(:params) { { fulltime: "False", parttime: "False", hasvacancies: "True" } }

    it "has study type filter" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end

    it "has vacancies filter" do
      expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
      expect(results_page.vacancies_filter.vacancies).to have_content("Only courses with vacancies")
      expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
    end
  end

  describe "filters with query string" do
    describe "study type filter" do
      context "for full time only" do
        let(:params) { { fulltime: "True", parttime: "False" } }

        it "has study type filter for full time only " do
          expect(results_page.study_type_filter.subheading).to have_content("Study type:")
          expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
          expect(results_page.study_type_filter).not_to have_parttime
          expect(results_page.study_type_filter.link).to have_content("Change study type")
        end
      end

      context "for part time only" do
        let(:params) { { fulltime: "False", parttime: "True" } }

        it "has study type filter for part time only" do
          expect(results_page.study_type_filter.subheading).to have_content("Study type:")
          expect(results_page.study_type_filter).not_to have_fulltime
          expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
          expect(results_page.study_type_filter.link).to have_content("Change study type")
        end
      end
    end

    describe "vacancies filter" do
      context "only courses with vacancies" do
        let(:params) { { hasvacancies: "True" } }

        it "has vacancies filter" do
          expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
          expect(results_page.vacancies_filter.vacancies).to have_content("Only courses with vacancies")
          expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
        end
      end

      context "courses with and without vacancies" do
        let(:params) { { hasvacancies: "False" } }

        it "has vacancies filter" do
          expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
          expect(results_page.vacancies_filter.vacancies).to have_content("Courses with and without vacancies")
          expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
        end
      end

      describe "salary filter" do
        context "only courses with salaries" do
          let(:params) { { funding: "8" } }

          it "has salaries filter" do
            expect(results_page.funding_filter.funding).to have_content("Only courses with a salary")
          end
        end

        context "courses with and without salaries" do
          let(:params) { { funding: "15" } }

          it "has salaries filter" do
            expect(results_page.funding_filter.funding).to have_content("Courses with and without salary")
          end
        end

        context "without any parameters" do
          it "defaults to courses with and without salaries" do
            expect(results_page.funding_filter.funding).to have_content("Courses with and without salary")
          end
        end
      end
    end

    describe "qualifications filter" do
      context "all selected" do
        let(:params) { { qualifications: "QtsOnly,PgdePgceWithQts,Other" } }

        it "displays text 'All qualifications'" do
          expect(results_page.qualifications_filter.qualifications.first).to have_content("All qualifications")
        end
      end

      context "two selected" do
        let(:params) { { qualifications: "QtsOnly,PgdePgceWithQts" } }

        it "displays text for each qualification" do
          expect(results_page.qualifications_filter.qualifications.first).to have_content("QTS only")
          expect(results_page.qualifications_filter.qualifications.last).to have_content("PGCE (or PGDE) with QTS")
          expect(results_page.qualifications_filter.qualifications.count).to eq(2)
        end
      end
    end
  end
end
