def results_page_parameters(parameters = {})
  {
    "filter[vacancies]" => "true",
    "filter[qualifications]" => "QtsOnly,PgdePgceWithQts,Other",
    "include" => "provider,sites",
    "page[page]" => 1,
    "page[per_page]" => 10,
    "sort" => "provider.provider_name,name",
  }.merge(parameters)
end
