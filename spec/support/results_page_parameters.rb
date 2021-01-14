def results_page_parameters(parameters = {})
  {
    'include' => 'site_statuses.site,provider,subjects',
    'page[page]' => 1,
    'page[per_page]' => 10,
    'sort' => 'provider.provider_name,name',
  }.merge(parameters)
end
