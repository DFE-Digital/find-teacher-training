require 'rails_helper'

describe '/sitemap.xml' do
  let(:provider) { build(:provider, provider_code: 'T92') }
  let(:current_recruitment_cycle) { build(:recruitment_cycle) }
  let(:changed_at) { Time.zone.now }
  let(:course) do
    build(
      :course,
      course_code: 'X102',
      provider:,
      provider_code: provider.provider_code,
      recruitment_cycle: current_recruitment_cycle,
      changed_at:,
    )
  end

  before do
    stub_api_v3_resource(
      type: RecruitmentCycle,
      params: {
        recruitment_cycle_year: RecruitmentCycle.current_year,
      },
      resources: current_recruitment_cycle,
    )

    stub_api_v3_resource(
      type: Course,
      params: {
        recruitment_cycle_year: RecruitmentCycle.current_year,
      },
      pagination: {
        page: 1,
        per_page: 20_000,
      },
      resources: course,
      fields: {
        courses: %w[course_code provider_code changed_at],
      },
    )

    get '/sitemap.xml'
  end

  it 'renders sitemap' do
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq(
      <<~XML,
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.google.com/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
          <url>
            <loc>http://www.example.com/</loc>
          </url>
          <url>
            <loc>http://www.example.com/results</loc>
          </url>
          <url>
            <loc>http://www.example.com/course/T92/X102</loc>
            <lastmod>#{changed_at.to_date.strftime('%Y-%m-%d')}</lastmod>
          </url>
        </urlset>
      XML
    )
  end
end
