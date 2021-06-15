require 'rails_helper'

describe '/results', type: :request do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  context 'a valid request' do
    before do
      stub_subjects
      stub_courses(query: results_page_parameters, course_count: 10)
    end

    it 'returns success (200)' do
      get '/results'
      expect(response).to have_http_status(200)
    end

    xit "sends an event to BigQuery" do
      get '/results'
      #expect(
    end

  end

  context 'API returns client error (400)' do
    before do
      stub_subjects
      stub_request(:get, courses_url)
        .with(query: results_page_parameters)
        .to_return(status: 400)
    end

    it 'returns unprocessable entity (422)' do
      get '/results'
      expect(response).to have_http_status(422)
    end
  end
end
