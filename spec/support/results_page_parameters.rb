def results_page_parameters(parameters = {})
  {
    'include' => 'provider,subjects,accredited_body',
    'filter[findable]' => true,
    'page[page]' => 1,
    'page[per_page]' => 10,
    'sort' => 'provider.name,name',
  }.merge(parameters)
end
