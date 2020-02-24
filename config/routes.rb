# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  scope module: "result_filters" do
    root to: "location#start"
  end

  scope module: "result_filters", path: "/start" do
    get "subject", to: "subject#start", as: "start_subject"
  end

  get "/terms-conditions", to: "pages#terms", as: "terms"
  get "/accessibility", to: "pages#accessibility", as: "accessibility"
  get "/privacy-policy", to: "pages#privacy", as: "privacy"
  get "/cookie-preferences", to: "pages#cookie_preferences", as: "cookie_preferences"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  resource :sitemap, only: :show

  get "/course/:provider_code/:course_code", to: "courses#show", as: "course"
  get "/results", to: "results#index", as: "results"

  get "/provider-suggestions", to: "provider_suggestions#index"
  get "/location-suggestions", to: "location_suggestions#index"

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
