require "rails_helper"

RSpec.describe ResultsView do
  let(:query_parameters) { ActionController::Parameters.new(parameter_hash) }

  let(:default_parameters) do
    {
      "qualifications" => "QtsOnly,PgdePgceWithQts,Other",
      "fulltime" => "False",
      "parttime" => "False",
      "hasvacancies" => "True",
      "senCourses" => "False",
    }
  end

  let(:subject_areas) do
    [
      build(:subject_area, subjects: [
        build(:subject, :primary),
        build(:subject, :biology),
        build(:subject, :english),
        build(:subject, :mathematics),
        build(:subject, :french),
        build(:subject, :russian),
      ]),
      build(:subject_area, :secondary),
    ]
  end

  before do
    stub_api_v3_resource(
      type: SubjectArea,
      resources: subject_areas,
      include: [:subjects],
    )
  end

  describe "query_parameters_with_defaults" do
    subject { described_class.new(query_parameters: query_parameters).query_parameters_with_defaults }

    context "params are empty" do
      let(:parameter_hash) { {} }

      it { is_expected.to eq(default_parameters) }
    end

    context "query_parameters have qualifications set" do
      let(:parameter_hash) { { "qualifications" => "Other" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "query_parameters have fulltime set" do
      let(:parameter_hash) { { "fulltime" => "True" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "query_parameters have parttime set" do
      let(:parameter_hash) { { "parttime" => "True" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "query_parameters have hasvacancies set" do
      let(:parameter_hash) { { "hasvacancies" => "False" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "query_parameters have senCourses set" do
      let(:parameter_hash) { { "senCourses" => "False" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "query_parameters not lose track of 'l' used by C# radio buttons" do
      let(:parameter_hash) { { "l" => "2" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "parameters without default present in query_parameters" do
      let(:parameter_hash) { {  "lat" => "52.3812321", "lng" => "-3.9440235" } }

      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end

    context "rails specific parameters are present" do
      let(:parameter_hash) { { "utf8" => true, "authenticity_token" => "booyah" } }

      it "filters them out" do
        expect(subject).to eq(default_parameters.merge({}))
      end
    end

    context "query_parameters have subjects set" do
      #TODO the query parameters are currently C# DB ids. They are converted internally
      #in this class but should also be C# parameters when they are output here
      #This will change when we fully switch to Rails

      let(:parameter_hash) { { "subjects" => "14,41,20" } }
      it { is_expected.to eq(default_parameters.merge(parameter_hash)) }
    end
  end

  describe "filter_path_with_unescaped_commas" do
    subject { described_class.new(query_parameters: default_parameters).filter_path_with_unescaped_commas("/test") }

    it "appends an unescaped querystring to the passed path" do
      expected_path = "/test?qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False"
      expect(subject).to eq(expected_path)
    end
  end

  describe "#qts_only?" do
    let(:results_view) { described_class.new(query_parameters: parameter_hash) }

    context "when the hash includes 'QTS only'" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly,PgdePgceWithQts" } }

      it "returns true" do
        expect(results_view.qts_only?).to be_truthy
      end
    end

    context "when the hash does not include 'QTS only'" do
      let(:parameter_hash) { { "qualifications" => "Other" } }

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
        expect(results_view.all_qualifications?).to be_truthy
      end
    end

    context "when not all selected" do
      let(:parameter_hash) { { "qualifications" => "QtsOnly" } }

      it "returns false" do
        expect(results_view.all_qualifications?).to be_falsy
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

    context "more than NUMBER_OF_SUBJECTS_DISPLAYED subjects are selected" do
      let(:parameter_hash) { { "subjects" => "1,2,3,4,5" } }

      it "returns the number of the extra subjects" do
        expect(results_view.number_of_extra_subjects).to eq(1)
      end
    end

    context "no subjects are selected" do
      let(:parameter_hash) { {} }

      it "returns the total number subjects - NUMBER_OF_SUBJECTS_DISPLAYED" do
        expect(results_view.number_of_extra_subjects).to eq(2)
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

  describe "#distance" do
    subject { described_class.new(query_parameters: parameter_hash).distance }

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

    it "returns an JSON query builder" do
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

  describe "#provider_filter?" do
    subject { described_class.new(query_parameters: parameter_hash).provider_filter? }

    context "when l param is set to 3" do
      let(:parameter_hash) { { "l" => "3" } }

      it { is_expected.to be(true) }
    end
  end

  describe "#subjects" do
    context "when no parameters are passed" do
      let(:results_view) { described_class.new(query_parameters: {}) }

      it "returns the first four subjects in alphabetical order" do
        expect(results_view.subjects.map(&:subject_name)).to eq(
          %w(
            Biology
            English
            French
            Mathematics
          ),
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
            ].join(","),
          })
        end

        let(:french_csharp_id) { 13 }
        let(:primary_csharp_id) { 31 }
        let(:spanish_csharp_id) { 44 }
        let(:mathematics_csharp_id) { 24 }
        let(:russian_csharp_id) { 41 }

        it "returns the first four matching subjects in alphabetical order" do
          expect(results_view.subjects.map(&:subject_name)).to eq(
            %w(
              French
              Mathematics
              Primary
              Russian
            ),
          )
        end
      end
    end
  end
end
