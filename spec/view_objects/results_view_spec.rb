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
  end

  describe "filter_path_with_unescaped_commas" do
    subject { described_class.new(query_parameters: default_parameters).filter_path_with_unescaped_commas("/test") }

    it "appends an unescaped querystring to the passed path" do
      expected_path = "/test?qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False"
      expect(subject).to eq(expected_path)
    end
  end
end
