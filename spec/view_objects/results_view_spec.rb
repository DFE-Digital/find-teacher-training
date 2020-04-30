require "rails_helper"

describe ResultsView do
  let(:query_parameters) { ActionController::Parameters.new(parameter_hash) }

  let(:default_output_parameters) do
    {
      "qualifications" => %w[QtsOnly PgdePgceWithQts Other],
      "fulltime" => false,
      "parttime" => false,
      "hasvacancies" => true,
      "senCourses" => false,
    }
  end

  let(:default_query_parameters) do
    {
      "qualifications" => %w[QtsOnly PgdePgceWithQts Other],
      "fulltime" => "false",
      "parttime" => "false",
      "hasvacancies" => "true",
      "senCourses" => "false",
    }
  end

  before do
    stub_request(
      :get,
      "http://localhost:3001/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
    ).to_return(
      body: File.new("spec/fixtures/api_responses/subjects_sorted_name_code.json"),
      headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )
  end

  describe "#query_parameters_with_defaults" do
    subject { described_class.new(query_parameters: query_parameters).query_parameters_with_defaults }

    context "params are empty" do
      let(:parameter_hash) { {} }

      it { is_expected.to eq(default_output_parameters) }
    end

    context "query_parameters have qualifications set" do
      let(:parameter_hash) { { "qualifications" => "Other" } }

      it { is_expected.to eq(default_output_parameters.merge(parameter_hash)) }
    end

    context "query_parameters have fulltime set" do
      let(:parameter_hash) { { "fulltime" => "true" } }

      it { is_expected.to eq(default_output_parameters.merge("fulltime" => true)) }
    end

    context "query_parameters have parttime set" do
      let(:parameter_hash) { { "parttime" => "true" } }

      it { is_expected.to eq(default_output_parameters.merge("parttime" => true)) }
    end

    context "query_parameters have hasvacancies set" do
      let(:parameter_hash) { { "hasvacancies" => "false" } }

      it { is_expected.to eq(default_output_parameters.merge("hasvacancies" => false)) }
    end

    context "query_parameters have senCourses set" do
      let(:parameter_hash) { { "senCourses" => "false" } }

      it { is_expected.to eq(default_output_parameters.merge("senCourses" => false)) }
    end

    context "query_parameters not lose track of 'l' used by C# radio buttons" do
      let(:parameter_hash) { { "l" => "2" } }

      it { is_expected.to eq(default_output_parameters.merge(parameter_hash)) }
    end

    context "parameters without default present in query_parameters" do
      let(:parameter_hash) { { "lat" => "52.3812321", "lng" => "-3.9440235" } }

      it { is_expected.to eq(default_output_parameters.merge(parameter_hash)) }
    end

    context "rails specific parameters are present" do
      let(:parameter_hash) { { "utf8" => "true", "authenticity_token" => "booyah" } }

      it "filters them out" do
        expect(subject).to eq(default_output_parameters.merge({}))
      end
    end

    context "query_parameters have subjects set" do
      # TODO: the query parameters are currently C# DB ids. They are converted internally
      # in this class but should also be C# parameters when they are output here
      # This will change when we fully switch to Rails

      let(:parameter_hash) { { "subjects" => "14,41,20" } }
      it { is_expected.to eq(default_output_parameters.merge(parameter_hash)) }
    end
  end

  describe "filter_path_with_unescaped_commas" do
    subject { described_class.new(query_parameters: default_query_parameters).filter_path_with_unescaped_commas("/test") }

    it "appends an unescaped querystring to the passed path" do
      expect(UnescapedQueryStringService).to receive(:call).with(base_path: "/test", parameters: default_output_parameters)
        .and_return("test_result")
      expect(subject).to eq("test_result")
    end
  end

  describe "#qts_only?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when the hash includes 'QTS only'" do
      let(:parameter_hash) { { "qualifications" => %w[QtsOnly PgdePgceWithQts] } }

      it "returns true" do
        expect(results_view.qts_only?).to be_truthy
      end
    end

    context "when the hash does not include 'QTS only'" do
      let(:parameter_hash) { { "qualifications" => %w[Other] } }

      it "returns false" do
        expect(results_view.qts_only?).to be_falsy
      end
    end
  end

  describe "#pgce_or_pgde_with_qts?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when the hash includes 'PGCE (or PGDE) with QTS'" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly,PgdePgceWithQts" } }

      it "returns true" do
        expect(results_view.pgce_or_pgde_with_qts?).to be_truthy
      end
    end

    context "when the hash does not include 'PGCE (or PGDE) with QTS'" do
      let(:parameter_hash) { { "qualifications" => "Other" } }

      it "returns false" do
        expect(results_view.pgce_or_pgde_with_qts?).to be_falsy
      end
    end
  end

  describe "#other_qualifications?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when the hash includes 'Further Education (PGCE or PGDE without QTS)'" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly,Other" } }

      it "returns true" do
        expect(results_view.other_qualifications?).to be_truthy
      end
    end

    context "when the hash does not include 'Further Education (PGCE or PGDE without QTS)'" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly" } }

      it "returns false" do
        expect(results_view.other_qualifications?).to be_falsy
      end
    end
  end

  describe "#all_qualifications?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when all selected'" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly,PgdePgceWithQts,Other" } }

      it "returns true" do
        expect(results_view.all_qualifications?).to eq(true)
      end
    end

    context "when not all selected" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly" } }

      it "returns false" do
        expect(results_view.all_qualifications?).to eq(false)
      end
    end
  end

  describe "#send_courses?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when the senCourses is True" do
      let(:parameter_hash) { { "senCourses" => "True" } }

      it "returns true" do
        expect(results_view.send_courses?).to be_truthy
      end
    end

    context "when the senCourses is nil" do
      let(:parameter_hash) { {} }

      it "returns false" do
        expect(results_view.send_courses?).to be_falsy
      end
    end
  end

  describe "#number_of_extra_subjects" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "The maximum number of subjects are selected" do
      let(:parameter_hash) { { "subjects" => (1..43).to_a } }

      it "Returns the number of extra subjects - 2" do
        expect(results_view.number_of_extra_subjects).to eq(37)
      end
    end

    context "more than NUMBER_OF_SUBJECTS_DISPLAYED subjects are selected" do
      let(:parameter_hash) { { "subjects" => %w[1 2 3 4 5] } }

      it "returns the number of the extra subjects" do
        expect(results_view.number_of_extra_subjects).to eq(1)
      end
    end

    context "no subjects are selected" do
      let(:parameter_hash) { {} }

      it "returns the total number subjects - NUMBER_OF_SUBJECTS_DISPLAYED" do
        expect(results_view.number_of_extra_subjects).to eq(37)
      end
    end
  end

  describe "#location" do
    subject { described_class.new(query_parameters: parameter_hash).location }

    context "when loc is passed" do
      let(:parameter_hash) { { "loc" => "Hogwarts" } }

      it { is_expected.to eq("Hogwarts") }
    end

    context "when loc is not passed" do
      let(:parameter_hash) { {} }
      it { is_expected.to eq("Across England") }
    end
  end

  describe "#radius" do
    subject { described_class.new(query_parameters: parameter_hash).radius }

    context "when rad is passed" do
      let(:parameter_hash) { { "rad" => "10" } }

      it { is_expected.to eq("10") }
    end
  end

  describe "#show_map?" do
    subject { described_class.new(query_parameters: parameter_hash).show_map? }

    context "when lng, lat and rad are passed" do
      let(:parameter_hash) { { "lng" => "0.3", "lat" => "0.2", "rad" => "10" } }

      it { is_expected.to be(true) }
    end

    context "when only rad is passed" do
      let(:parameter_hash) { { "rad" => "10" } }

      it { is_expected.to be(false) }
    end

    context "when only lat is passed" do
      let(:parameter_hash) { { "lat" => "0.10" } }

      it { is_expected.to be(false) }
    end

    context "when only lng is passed" do
      let(:parameter_hash) { { "lng" => "1.0" } }

      it { is_expected.to be(false) }
    end

    context "when no params are passed" do
      let(:parameter_hash) { {} }

      it { is_expected.to be(false) }
    end
  end

  describe "#courses" do
    let(:results_view) { described_class.new(query_parameters: {}) }

    it "returns a JSON query builder" do
      expect(results_view.courses).to be_a(JsonApiClient::Query::Builder)
    end
  end

  describe "#map_image_url" do
    subject { described_class.new(query_parameters: parameter_hash).map_image_url }

    let(:parameter_hash) do
      {
        "loc" => "Hogwarts, Reading, UK",
        "rad" => "10",
        "lng" => "-27.1504002",
        "lat" => "-109.3042697",
      }
    end

    before do
      allow(Settings).to receive_message_chain(:google, :maps_api_key).and_return("yellowskullkey")
      allow(Settings).to receive_message_chain(:google, :maps_api_url).and_return("https://maps.googleapis.com/maps/api/staticmap")
    end

    it { is_expected.to eq("https://maps.googleapis.com/maps/api/staticmap?key=yellowskullkey&center=-109.3042697,-27.1504002&zoom=11&size=300x200&scale=2&markers=-109.3042697,-27.1504002") }
  end

  describe "#provider" do
    subject { described_class.new(query_parameters: parameter_hash).provider }

    context "when query is passed" do
      let(:parameter_hash) { { "query" => "Kamino" } }

      it { is_expected.to eq("Kamino") }
    end
  end

  describe "#location_filter?" do
    subject { described_class.new(query_parameters: parameter_hash).location_filter? }

    context "when l param is set to 1" do
      let(:parameter_hash) { { "l" => "1" } }

      it { is_expected.to be(true) }
    end

    context "when l param is not set to 1" do
      let(:parameter_hash) { { "l" => "2" } }

      it { is_expected.to be(false) }
    end
  end

  describe "#england_filter?" do
    subject { described_class.new(query_parameters: parameter_hash).england_filter? }

    context "when l param is set to 2" do
      let(:parameter_hash) { { "l" => "2" } }

      it { is_expected.to be(true) }
    end

    context "when l param is not set to 2" do
      let(:parameter_hash) { { "l" => "3" } }

      it { is_expected.to be(false) }
    end
  end

  describe "#provider_filter?" do
    subject { described_class.new(query_parameters: parameter_hash).provider_filter? }

    context "when l param is set to 3" do
      let(:parameter_hash) { { "l" => "3" } }

      it { is_expected.to be(true) }
    end

    context "when l param is not set to 3" do
      let(:parameter_hash) { { "l" => "2" } }

      it { is_expected.to be(false) }
    end
  end

  describe "#vacancy_filter?" do
    subject { described_class.new(query_parameters: parameter_hash).vacancy_filter? }

    context "when hasvacancies param is set to true" do
      let(:parameter_hash) { { "hasvacancies" => "true" } }

      it { is_expected.to be(false) }
    end

    context "when hasvacancies param is set to false" do
      let(:parameter_hash) { { "hasvacancies" => "false" } }

      it { is_expected.to be(true) }
    end
  end

  describe "#course_count" do
    subject { described_class.new(query_parameters: {}).course_count }

    context "there are more than three results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/ten_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to be(10) }
    end

    context "there are no results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/empty_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to be(0) }
    end
  end

  describe "#subjects" do
    context "when no parameters are passed" do
      let(:results_view) { described_class.new(query_parameters: {}) }

      it "returns the first four subjects in alphabetical order" do
        expect(results_view.subjects.map(&:subject_name)).to eq(
          [
            "Art and design",
            "Biology",
            "Business studies",
            "Chemistry",
          ],
        )
      end

      context "when subject parameters are passed" do
        let(:results_view) do
          described_class.new(query_parameters: {
            "subjects" => [
              french_csharp_id,
              russian_csharp_id,
              primary_csharp_id,
              spanish_csharp_id,
              mathematics_csharp_id,
            ],
          })
        end

        let(:french_csharp_id) { "13" }
        let(:primary_csharp_id) { "31" }
        let(:spanish_csharp_id) { "44" }
        let(:mathematics_csharp_id) { "24" }
        let(:russian_csharp_id) { "41" }

        it "returns the first four matching subjects in alphabetical order" do
          expect(results_view.subjects.map(&:subject_name)).to eq(
            %w[
              French
              Mathematics
              Primary
              Russian
            ],
          )
        end
      end

      describe "#suggested_search_visible?" do
        subject { described_class.new(query_parameters: { "lat" => "0.1", "lng" => "2.4", "rad" => "5" }).suggested_search_visible? }

        def suggested_search_count_parameters
          results_page_parameters.reject do |k, _v|
            ["page[page]", "page[per_page]", "sort"].include?(k)
          end
        end

        context "there are more than three results" do
          before do
            stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
              .with(query: results_page_parameters)
              .to_return(
                body: File.new("spec/fixtures/api_responses/ten_courses.json"),
                headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
              )
          end

          it { is_expected.to be(false) }
        end

        context "there are less than three results" do
          context "there are suggested courses found" do
            before do
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: results_page_parameters)
                .to_return(
                  body: File.new("spec/fixtures/api_responses/two_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters.merge("filter[latitude]" => 0.1, "filter[longitude]" => 2.4, "filter[radius]" => 10))
                .to_return(
                  body: File.new("spec/fixtures/api_responses/four_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters.merge("filter[latitude]" => 0.1, "filter[longitude]" => 2.4, "filter[radius]" => 20))
                .to_return(
                  body: File.new("spec/fixtures/api_responses/ten_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
            end

            it { is_expected.to be(true) }
          end

          context "there are no suggested courses found" do
            before do
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: results_page_parameters)
                .to_return(
                  body: File.new("spec/fixtures/api_responses/two_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters.merge("filter[latitude]" => 0.1, "filter[longitude]" => 2.4, "filter[radius]" => 10))
                .to_return(
                  body: File.new("spec/fixtures/api_responses/empty_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters.merge("filter[latitude]" => 0.1, "filter[longitude]" => 2.4, "filter[radius]" => 20))
                .to_return(
                  body: File.new("spec/fixtures/api_responses/empty_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters.merge("filter[latitude]" => 0.1, "filter[longitude]" => 2.4, "filter[radius]" => 50))
                .to_return(
                  body: File.new("spec/fixtures/api_responses/empty_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
              stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
                .with(query: suggested_search_count_parameters)
                .to_return(
                  body: File.new("spec/fixtures/api_responses/empty_courses.json"),
                  headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
                )
            end

            it { is_expected.to be(false) }
          end
        end
      end
    end
  end

  describe "#site_distance" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "closest site distance is greater than 1 mile" do
      let(:parameter_hash) { { "lat" => "51.4975", "lng" => "0.1357" } }

      it "calculates the distance to the closest site, rounding to one decimal place" do
        site1 = build(:site, latitude: 51.5079, longitude: 0.0877, address1: "1 Foo Street", postcode: "BAA0NE")
        site2 = build(:site, latitude: 54.9783, longitude: 1.6178, address1: "2 Foo Street", postcode: "BAA0NE")

        course = build(:course, site_statuses: [
          build(:site_status, :full_time_and_part_time, site: site1),
          build(:site_status, :full_time_and_part_time, site: site2),
        ])

        expect(results_view.site_distance(course)).to eq(2)
      end
    end

    context "closest site distance is less than 1 mile" do
      let(:parameter_hash) { { "lat" => "51.4975", "lng" => "0.1357" } }

      it "calculates the distance to the closest site, rounding to one decimal place" do
        site1 = build(:site, latitude: 51.4985, longitude: 0.1367, address1: "1 Foo Street", postcode: "BAA0NE")
        site2 = build(:site, latitude: 54.9783, longitude: 1.6178, address1: "2 Foo Street", postcode: "BAA0NE")

        course = build(:course, site_statuses: [
          build(:site_status, :full_time_and_part_time, site: site1),
          build(:site_status, :full_time_and_part_time, site: site2),
        ])

        expect(results_view.site_distance(course)).to eq(0.1)
      end
    end
  end

  describe "#nearest_address" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }
    let(:parameter_hash) { { "lat" => "51.4975", "lng" => "0.1357" } }
    let(:geocoder) { double("geocoder") }

    it "returns the address to the nearest site" do
      site1 = build(:site,
                    latitude: 51.4985,
                    longitude: 0.1367,
                    address1: "10 Windy Way",
                    address2: "Witham",
                    address3: "Essex",
                    address4: "UK",
                    postcode: "CM8 2SD")
      site2 = build(:site, latitude: 54.9783, longitude: 1.6178)
      site3 = build(:site,
                    latitude: nil,
                    longitude: nil,
                    address1: "10 Windy Way",
                    address2: "Witham",
                    address3: "Essex",
                    address4: "UK",
                    postcode: "CM8 2SD")

      course = build(:course, site_statuses: [
        build(:site_status, :full_time_and_part_time, site: site1),
        build(:site_status, :full_time_and_part_time, site: site2),
        build(:site_status, :full_time_and_part_time, site: site3),
      ])

      allow(Geokit::LatLng).to receive(:new).and_return(geocoder)
      allow(geocoder).to receive(:distance_to).with("51.4985,0.1367")
      allow(geocoder).to receive(:distance_to).with(",").and_raise(Geokit::Geocoders::GeocodeError)

      expect(results_view.nearest_address(course)).to eq("10 Windy Way, Witham, Essex, UK, CM8 2SD")
    end
  end

  describe "#sort_options" do
    context "location query" do
      subject { described_class.new(query_parameters: { "l" => "1" }).sort_options }
      it {
        is_expected.to eq(
          [
            ["Training provider (A-Z)", 0, { "data-qa": "sort-form__options__ascending" }],
            ["Training provider (Z-A)", 1, { "data-qa": "sort-form__options__descending" }],
            ["Distance", 2, { "data-qa": "sort-form__options__distance" }],
          ],
        )
      }
    end

    context "all other queries" do
      subject { described_class.new(query_parameters: {}).sort_options }
      it {
        is_expected.to eq(
          [
            ["Training provider (A-Z)", 0, { "data-qa": "sort-form__options__ascending" }],
            ["Training provider (Z-A)", 1, { "data-qa": "sort-form__options__descending" }],
          ],
        )
      }
    end
  end

  describe "#no_results_found?" do
    subject { described_class.new(query_parameters: {}).no_results_found? }

    context "there are more than three results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/ten_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to eq(false) }
    end

    context "there are no results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/empty_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to eq(true) }
    end
  end

  describe "#number_of_courses_string" do
    subject { described_class.new(query_parameters: {}).number_of_courses_string }

    context "there are two results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/two_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to eq("2 courses") }
    end

    context "there is one result" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/one_course.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to eq("1 course") }
    end

    context "there are no results" do
      before do
        stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
          .with(query: results_page_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/empty_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )
      end

      it { is_expected.to eq("No courses") }
    end
  end

  describe "#total_pages" do
    let(:parameter_hash) { {} }

    subject { described_class.new(query_parameters: query_parameters) }

    def stub_request_with_meta_count(count)
      stub_request(:get, "http://localhost:3001/api/v3/recruitment_cycles/2020/courses")
        .with(query: results_page_parameters)
        .to_return(
          body: { meta: { count: count } }.to_json,
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
    end

    context "where there are no results" do
      before do
        stub_request_with_meta_count(0)
      end

      it "should return 0 pages" do
        expect(subject.total_pages).to eql(0)
      end
    end

    context "where there are 10 results" do
      before do
        stub_request_with_meta_count(10)
      end

      it "should return 1 page" do
        expect(subject.total_pages).to eql(1)
      end
    end

    context "where there are 20 results" do
      before do
        stub_request_with_meta_count(20)
      end

      it "should return 2 pages" do
        expect(subject.total_pages).to eql(2)
      end
    end
  end
end
