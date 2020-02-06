def stub_results_page_request
  current_recruitment_cycle = build(:recruitment_cycle)

  provider = build(
    :provider,
    provider_name: "ACME SCITT A0",
    provider_code: "T92",
    website: "https://scitt.org",
    address1: "1 Long Rd",
    postcode: "E1 ABC",
  )

  courses = [
    build(
      :course,
      name: "Primary",
      course_code: "X130",
      provider: provider,
      provider_code: provider.provider_code,
      recruitment_cycle: current_recruitment_cycle,
    ),
  ]

  fields = {
    courses: %i[provider_code course_code name description funding_type provider accrediting_provider subjects],
    providers: %i[provider_name address1 address2 address3 address4 postcode],
  }

  params = {
    recruitment_cycle_year: Settings.current_cycle,
    provider_code: nil,
  }

  pagination = { page: 1, per_page: 10 }

  include = %i[provider accrediting_provider financial_incentive subjects]

  stub_api_v3_resource(
    type: Course,
    resources: courses,
    params: params,
    fields: fields,
    include: include,
    pagination: pagination,
    links: {
      last: api_v3_url(
        type: Course,
        params: params,
        fields: fields,
        include: include,
        pagination: pagination,
      ),
    },
  )

  stub_api_v3_resource(
    type: SubjectArea,
    resources: nil,
    include: [:subjects],
  )
end
