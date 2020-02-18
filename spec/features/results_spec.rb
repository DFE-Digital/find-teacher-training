require "rails_helper"

feature "results", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:params) {}
  let(:subject_areas) do
    [
      build(:subject_area, subjects: [
        build(:subject, :primary, id: 1),
        build(:subject, :biology, id: 10),
        build(:subject, :english, id: 21),
        build(:subject, :mathematics, id: 25),
        build(:subject, :french, id: 34),
      ]),
      build(:subject_area, :secondary),
    ]
  end
  let(:default_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  let(:base_parameters) do
    {
      "filter[vacancies]" => "true",
      "filter[qualifications]" => "QtsOnly,PgdePgceWithQts,Other",
      "include" => "provider",
      "page[page]" => 1,
      "page[per_page]" => 10,
    }
  end

  let(:courses) {
    File.new("spec/fixtures/api_responses/courses.json")
  }

  before do
    stub_api_v3_resource(
      type: SubjectArea,
      resources: subject_areas,
      include: [:subjects],
    )

    stub_request(:get, default_url)
      .with(query: base_parameters)
      .to_return(
        body: courses,
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )

    allow(Settings).to receive_message_chain(:google, :maps_api_key).and_return("alohomora")
    allow(Settings).to receive_message_chain(:google, :maps_api_url).and_return("https://maps.googleapis.com/maps/api/staticmap")
    visit results_path(params)
  end

  describe "course count" do
    context "when API returns two courses" do
      it "displays the correct course count" do
        expect(results_page.course_count).to have_content("2 courses found")
      end
    end

    context "when API return no courses" do
      let(:courses) {
        File.new("spec/fixtures/api_responses/empty_courses.json")
      }

      it "displays the correct course count" do
        expect(results_page.course_count).to have_content("0 courses found")
      end
    end
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

    it "has location filter" do
      expect(results_page.location_filter.name).to have_content("Across England")
      expect(results_page.location_filter).to have_no_distance
      expect(results_page.location_filter.link).to have_content("Change location or choose a provider")
      results_page.location_filter.link.click
      location_filter_uri = URI(current_url)
      expect(location_filter_uri.path).to eq("/results/filter/location")
      expect(location_filter_uri.query).to eq("qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False")
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

    it "has location filter" do
      expect(results_page.location_filter.name).to have_content("Across England")
      expect(results_page.location_filter).to have_no_distance
    end
  end

  describe "subjects filter" do
    context "no subjects selected" do
      let(:params) { { subjects: {} } }

      it "defaults to all subjects without 'Only SEND courses'" do
        expect(results_page.subjects_filter).not_to have_send_courses
        expect(results_page.subjects_filter).to have_content("Biology")
        expect(results_page.subjects_filter).to have_content("English")
        expect(results_page.subjects_filter).to have_content("French")
        expect(results_page.subjects_filter).to have_content("Mathematics")
        expect("Biology").to appear_before("English")
        expect("English").to appear_before("French")
        expect("French").to appear_before("Mathematics")
        expect(results_page.subjects_filter.extra_subjects).to have_content("and 1 more...")
      end
    end

    context "up to 4 subjects selected" do
      let(:params) { { subjects: "31,1" } }

      it "displays all selected subjects in alphabetical order" do
        expect(results_page.subjects_filter).not_to have_send_courses
        expect(results_page.subjects_filter).to have_content("Biology")
        expect(results_page.subjects_filter).to have_content("Primary")
        expect("Biology").to appear_before("Primary")
      end
    end

    context "more than 4 subjects selected" do
      let(:params) { { subjects: "31,1,12,24,13" } }

      it "displays first 4 subjects and number of extra courses selected" do
        expect(results_page.subjects_filter).to have_content("Biology")
        expect(results_page.subjects_filter).to have_content("English")
        expect(results_page.subjects_filter).to have_content("French")
        expect(results_page.subjects_filter).to have_content("Mathematics")
        expect(results_page.subjects_filter.extra_subjects).to have_content("and 1 more...")
      end

      context "'Only SEND courses' selected" do
        let(:params) { { subjects: "31,1,12,24,13", senCourses: "true" } }

        it "displays 'Only SEND courses' at the top of the list and doesn't count towards 4 items rule" do
          expect(results_page.subjects_filter.send_courses).to have_content("Only SEND courses")
          expect(results_page.subjects_filter).to have_content("Biology")
          expect(results_page.subjects_filter).to have_content("English")
          expect(results_page.subjects_filter).to have_content("French")
          expect(results_page.subjects_filter).to have_content("Mathematics")
          expect(results_page.subjects_filter.extra_subjects).to have_content("and 1 more...")
          expect("Only SEND courses").to appear_before("Biology")
        end
      end
    end
  end

  describe "provider filter" do
    context "provider selected" do
      let(:params) { { query: "Junior Middle Lower Upper Second Fifth High", l: "3" } }

      it "displays the provider filter" do
        expect(results_page.provider_title).to have_content("Junior Middle Lower Upper Second Fifth High")
        expect(results_page).to_not have_location_filter
        expect(results_page.provider_filter.name).to have_content("Junior Middle Lower Upper Second Fifth High")
        results_page.provider_filter.link.click
        provider_filter_uri = URI(current_url)
        expect(provider_filter_uri.path).to eq("/results/filter/location")
        expect(provider_filter_uri.query).to eq("l=3&query=Junior+Middle+Lower+Upper+Second+Fifth+High&qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False")
      end
    end
  end

  describe "location filter" do
    context "location selected within 10 miles" do
      let(:params) do
        {
          loc: "Hogwarts, Reading, UK",
          rad: "10",
          lng: "-27.1504002",
          lat: "-109.3042697",
        }
      end

      it "displays the location filter" do
        expected_url = "https://maps.googleapis.com/maps/api/staticmap?key=alohomora&center=-109.3042697,-27.1504002&zoom=11&size=300x200&scale=2&markers=-109.3042697,-27.1504002"
        expect(results_page.location_filter.name).to have_content("Hogwarts, Reading, UK")
        expect(results_page.location_filter.distance).to have_content("Within 10 miles of the pin")
        expect(results_page.location_filter.map["src"]).to have_content(expected_url)
        results_page.location_filter.link.click
        location_filter_uri = URI(current_url)
        expect(location_filter_uri.path).to eq("/results/filter/location")
        expect(location_filter_uri.query).to eq("lat=-109.3042697&lng=-27.1504002&loc=Hogwarts,+Reading,+UK&rad=10&qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False")
      end
    end
  end
end
