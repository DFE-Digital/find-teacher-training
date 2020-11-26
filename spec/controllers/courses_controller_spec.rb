require 'rails_helper'

RSpec.describe CoursesController do
  let(:provider) { build(:provider) }
  let(:course) { build(:course, provider: provider) }

  describe '#apply' do
    context 'when course is found' do
      let(:logger) { double(:logger) }

      before do
        stub_api_v3_resource(
          type: Course,
          params: {
            recruitment_cycle_year: Settings.current_cycle,
            provider_code: course.provider_code,
            course_code: course.course_code,
          },
          resources: course,
          include: %w[provider],
        )
      end

      it 'redirects to correct apply destination' do
        get :apply, params: { provider_code: course.provider_code, course_code: course.course_code }
        expect(response).to redirect_to("https://www.apply-for-teacher-training.service.gov.uk/candidate/apply?providerCode=#{course.provider.provider_code}&courseCode=#{course.course_code}")
      end

      it 'writes to log' do
        allow(Rails).to receive(:logger).and_return(logger)
        expect(logger).to receive(:info).with("Course apply conversion. Provider: #{course.provider.provider_code}. Course: #{course.course_code}")

        get :apply, params: { provider_code: course.provider_code, course_code: course.course_code }
      end
    end

    context 'when a course is not found' do
      before do
        stub_request(
          :get,
          "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{Settings.current_cycle}/providers/#{course.provider_code}/courses/#{course.course_code}?include=provider",
        ).to_raise(JsonApiClient::Errors::NotFound)
      end

      it 'redirects to the not found page' do
        get :apply, params: { provider_code: course.provider_code, course_code: course.course_code }
        expect(response.status).to eq(404)
      end
    end
  end
end
