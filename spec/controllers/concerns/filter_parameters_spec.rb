require_relative '../../../app/controllers/concerns/filter_parameters'
require 'active_support/core_ext'

RSpec.describe FilterParameters do
  let(:test_class) do
    Class.new do
      include FilterParameters

      attr_reader :request

      def initialize(request:)
        @request = request
      end

      def params
        request.query_parameters
      end
    end
  end
  let(:request) do
    instance_double(ActionDispatch::Request, method: verb, query_parameters:, request_parameters:)
  end
  let(:query_parameters) { {} }
  let(:request_parameters) { {} }
  let(:verb) { 'GET' }

  subject(:test_class_subject) { test_class.new(request:) }

  describe '#filter_params' do
    context 'GET' do
      context 'when rails parameters are present' do
        let(:query_parameters) { { 'utf8' => true, 'authenticity_token' => 'token', 'test' => 'test' } }

        it 'they are stripped' do
          expect(test_class_subject.filter_params).to eq({ 'test' => 'test' })
        end
      end

      context 'when pagination parameters are present' do
        let(:query_parameters) { { 'page' => 3, 'test' => 'test' }.with_indifferent_access }

        it 'they are stripped' do
          expect(test_class_subject.filter_params).to eq({ 'test' => 'test' })
        end
      end
    end

    context 'POST' do
      let(:verb) { 'POST' }
      let(:request_parameters) { { 'test' => 'request' } }
      let(:query_parameters) { { 'test' => 'query' } }

      it 'uses request_parameters' do
        expect(test_class_subject.filter_params['test']).to eq('request')
      end

      context 'when pagination parameters are present' do
        let(:request_parameters) { { 'page' => 3, 'test' => 'test' } }

        it 'they are stripped' do
          expect(test_class_subject.filter_params).to eq({ 'test' => 'test' })
        end
      end
    end

    context 'HEAD' do
      let(:verb) { 'HEAD' }
      let(:query_parameters) { { 'utf8' => true, 'authenticity_token' => 'token', 'test' => 'test' } }

      it 'returns the query parameters' do
        expect(test_class_subject.filter_params).to eq({ 'test' => 'test' })
      end
    end
  end

  describe '#filter_params_without_previous_parameters' do
    let(:query_parameters) { { 'l' => 0, 'prev_l' => 1, 'prev_query' => 'query', 'test' => 'test' } }

    it 'removes the previous parameters' do
      expect(test_class_subject.filter_params_without_previous_parameters).to eq({ 'l' => 0, 'test' => 'test' })
    end
  end

  describe '#merge_previous_parameters' do
    let(:query_parameters) { { 'l' => 0, 'prev_l' => 1, 'prev_query' => 'query', 'test' => 'test' } }

    it 'sets the non prev equivalent and adds any that are not present' do
      expect(test_class_subject.merge_previous_parameters(query_parameters)).to eq({ 'l' => 1, 'query' => 'query', 'test' => 'test' })
    end

    context 'where param is set to none' do
      let(:query_parameters) { { 'l' => 0, 'prev_l' => 1, 'prev_query' => 'query', 'test' => 'test', 'prev_lat' => 'none' } }

      it 'ignores them' do
        expect(test_class_subject.merge_previous_parameters(query_parameters)).to eq({ 'l' => 1, 'query' => 'query', 'test' => 'test' })
      end
    end
  end
end
