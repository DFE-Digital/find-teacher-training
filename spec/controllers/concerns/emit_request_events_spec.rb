require 'rails_helper'

RSpec.describe EmitRequestEvents, type: :request, with_bigquery: true do
  let(:provider_user) { create(:provider_user, :with_dfe_sign_in) }
  let(:project) { instance_double(Google::Cloud::Bigquery::Project, dataset: dataset) }
  let(:dataset) { instance_double(Google::Cloud::Bigquery::Dataset, table: table) }
  let(:table) { instance_double(Google::Cloud::Bigquery::Table) }

  before do
    activate_feature(:send_web_requests_to_bigquery)
    allow(Google::Cloud::Bigquery).to receive(:new).and_return(project)
    allow(table).to receive(:insert)
  end

  it 'enqueues job to send event to bigquery' do
    get '/', headers: { 'HTTP_USER_AGENT' => 'test user agent' }

    expect(SendEventToBigqueryJob).to have_been_enqueued.exactly(:once)

    job_args = enqueued_jobs.last[:args]

    expect(job_args.first['event_type']).to eq('web_request')
  end
end
