Rails.application.routes.draw do
  get :ping, controller: :heartbeat
  get :healthcheck, controller: :heartbeat
  get :sha, controller: :heartbeat

  get '/cycle-has-ended', to: 'pages#cycle_has_ended', as: 'cycle_has_ended'
  get '/maintainance', to: 'pages#maintainance', as: 'maintainance'

  get '/cycle-ending-soon', to: redirect('/', status: :moved_permanently)
  # During the cycle there is no need for a separate path for
  # start#location but this was the root path in the
  # legacy c# app so we're redirecting to root
  get '/start/location', to: redirect('/', status: '301')

  get '/cycles', to: 'switcher#cycles', as: :cycles

  post '/cycles', to: 'switcher#update', as: :switch_cycle_schedule

  get '/feature-flags', to: 'feature_flags#index'
  post '/feature-flags' => 'feature_flags#update'

  get '/confirm-environment' => 'confirm_environment#new'
  post '/confirm-environment' => 'confirm_environment#create'

  # Old search flow: now redirects
  get '/start/subject', to: redirect('/')

  # new search flow
  scope module: 'search' do
    get '/age-groups' => 'age_groups#new'
    get '/age-groups-submit' => 'age_groups#create', as: :age_groups_create
    get '/subjects' => 'subjects#new'
    get '/subjects-submit' => 'subjects#create', as: :subjects_create
  end

  scope module: 'result_filters' do
    root to: 'location#start'
  end

  get '/terms-conditions', to: 'pages#terms', as: 'terms'
  get '/accessibility', to: 'pages#accessibility', as: 'accessibility'
  get '/privacy-policy', to: 'pages#privacy', as: 'privacy'

  get '/cookies', to: 'cookie_preferences#new', as: 'cookie_preferences'
  post '/cookies', to: 'cookie_preferences#create', as: 'create_cookie_preferences'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  resource :sitemap, only: :show

  get '/course/:provider_code/:course_code/apply', to: 'courses#apply', as: :apply
  get '/course/:provider_code/:course_code', to: 'courses#show', as: 'course'
  get '/results', to: 'results#index', as: 'results'

  get '/location-suggestions', to: 'location_suggestions#index'

  scope module: 'result_filters', path: '/results/filter' do
    get 'location', to: 'location#new'
    post 'location', to: 'location#create'

    get 'subject', to: 'subject#new'
    post 'subject', to: 'subject#create'

    get 'studytype', to: 'study_type#new'
    post 'studytype', to: 'study_type#create'

    get 'vacancy', to: 'vacancy#new'
    post 'vacancy', to: 'vacancy#create'

    get 'funding', to: 'funding#new'
    post 'funding', to: 'funding#create'

    get 'qualification', to: 'qualification#new'
    post 'qualification', to: 'qualification#create'

    get 'subject', to: 'subject#new'
    post 'subject', to: 'subject#create'

    get 'provider', to: 'provider#new'
  end
end
