def results_page_parameters(parameters = {})
  {
    'filter[has_vacancies]' => 'true',
    'include' => 'site_statuses.site,provider',
    'fields' =>
      {
        'courses' => 'name,course_code,provider_code,study_mode,qualification,funding_type,provider_type,level,provider,site_statuses',
        'providers' => 'provider_name,address1,address2,address3,address4,postcode',
        'site_statuses' => 'status,has_vacancies?,site',
      },
    'page[page]' => 1,
    'page[per_page]' => 30,
    'sort' => 'provider.provider_name,name',
  }.merge(parameters)
end
