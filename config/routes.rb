# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  scope module: "result_filters" do
    root to: "location#start"
  end

  if Settings.redirect_results_to_c_sharp
    get "/start/subject", to: redirect { |_params, request| ["#{Settings.search_and_compare_ui.base_url}/start/subject", request.query_string.presence&.gsub("%2C", ",")].compact.join("?") }, as: "start_subject"
  else # Stub until we add the start subject page
    get "/start/subject", to: "errors#not_found", as: "start_subject"
  end

  get "/terms-conditions", to: "pages#terms", as: "terms"
  get "/accessibility", to: "pages#accessibility", as: "accessibility"
  get "/privacy-policy", to: "pages#privacy", as: "privacy"
  get "/cookies", to: "pages#cookies", as: "cookies"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  get "/course/:provider_code/:course_code", to: "courses#show", as: "course"
  get "/results", to: "results#index", as: "results"

  get "/provider-suggestions", to: "provider_suggestions#index"

  scope module: "result_filters", path: "/results/filter" do
    get "location", to: "location#new"
    post "location", to: "location#create"

    get "subject", to: "subject#new"
    post "subject", to: "subject#create"

    get "studytype", to: "study_type#new"
    post "studytype", to: "study_type#create"

    get "vacancy", to: "vacancy#new"
    post "vacancy", to: "vacancy#create"

    get "funding", to: "funding#new"
    post "funding", to: "funding#create"

    get "qualification", to: "qualification#new"
    post "qualification", to: "qualification#create"

    get "subject", to: "subject#new"
    post "subject", to: "subject#create"

    get "provider", to: "provider#new"
  end
end
# rubocop:enable Metrics/BlockLength
