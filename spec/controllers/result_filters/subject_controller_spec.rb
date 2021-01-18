require 'rails_helper'

RSpec.describe ResultFilters::SubjectController do
  include StubbedRequests::SubjectAreas

  describe '#new' do
    context 'when subjects is a comma delimited string' do
      it 'returns a 200' do
        stub_subject_areas

        get :new, params: { subjects: '38,29' }
        expect(response).to be_successful
      end
    end
  end
end
