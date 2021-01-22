require 'rails_helper'

RSpec.describe CoursesController do
  let(:provider) { build(:provider) }
  let(:course) { build(:course, provider: provider) }

  describe '#apply' do
    context 'when course is found' do
      let(:logger) { instance_double(Logger) }

      before do
        stub_teacher_training_api_resource(
          type: Course,
          params: {
            recruitment_cycle_year: Settings.current_cycle,
            provider_code: course.provider.code,
            course_code: course.code,
          },
          resources: course,
          include: %w[provider],
        )
      end

      it 'redirects to correct apply destination' do
        get :apply, params: { provider_code: course.provider.code, course_code: course.code }
        expect(response).to redirect_to("https://www.apply-for-teacher-training.service.gov.uk/candidate/apply?providerCode=#{course.provider.code}&courseCode=#{course.code}")
      end

      it 'writes to log' do
        allow(logger).to receive(:info)
        allow(Rails).to receive(:logger).and_return(logger)

        get :apply, params: { provider_code: course.provider.code, course_code: course.code }

        expect(logger).to have_received(:info).with("Course apply conversion. Provider: #{course.provider.code}. Course: #{course.code}")
      end
    end

    context 'when a course is not found' do
      before do
        stub_request(
          :get,
          "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}/recruitment_cycles/#{Settings.current_cycle}/providers/#{course.provider.code}/courses/#{course.code}?include=provider",
        ).to_raise(JsonApiClient::Errors::NotFound)
      end

      it 'redirects to the not found page' do
        get :apply, params: { provider_code: course.provider.code, course_code: course.code }
        expect(response.status).to eq(404)
      end
    end
  end
end
