def results_page_parameters(parameters = {})
  {
    "filter[has_vacancies]" => "true",
    "include" => "provider,sites,subjects",
    "page[page]" => 1,
    "page[per_page]" => 10,
    "sort" => "provider.provider_name,name",
  }.merge(parameters)
end
