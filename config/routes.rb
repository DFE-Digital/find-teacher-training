# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect(Settings.search_and_compare_ui.base_url)

  get "/terms-conditions", to: "pages#terms", as: "terms"
  get "/accessibility", to: "pages#accessibility", as: "accessibility"
  get "/privacy-policy", to: "pages#privacy", as: "privacy"
  get "/cookies", to: "pages#cookies", as: "cookies"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  get "/course/:provider_code/:course_code", to: "courses#show", as: "course"
  get "/results", to: "results#index", as: "results"

  scope module: "filters", path: "/results/filter" do
    get "studytype", to: "study_type#new"
    post "studytype", to: "study_type#create"
    get "vacancy", to: "vacancy#new"
    post "vacancy", to: "vacancy#create"
    get "funding", to: "funding#new"
    post "funding", to: "funding#create"
  end
end
