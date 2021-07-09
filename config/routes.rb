Rails.application.routes.draw do
  constraints(host: /^www2\.|\.education\./) do
    match '/(*path)' => redirect { |_, req| "#{Settings.base_url}#{req.fullpath}" },
          via: %i[get post put]
  end

  get :ping, controller: :heartbeat
  get :healthcheck, controller: :heartbeat
  get :sha, controller: :heartbeat

  if FeatureFlag.active?(:cycle_has_ended) || CycleTimetable.find_down?
    get '/cycle-has-ended', to: 'pages#cycle_has_ended', as: 'cycle_has_ended'
    get '/', to: redirect('/cycle-has-ended', status: 302)
    get '/results', to: redirect('/cycle-has-ended', status: 302), as: 'results_redirect'
    get '/course/*path', to: redirect('/cycle-has-ended', status: 302)
    get '/start/*path', to: redirect('/cycle-has-ended', status: 302)
  else
    get '/cycle-has-ended', to: redirect('/', status: 301)
  end

  if FeatureFlag.active?(:cycle_ending_soon) || CycleTimetable.preview_mode?
    root to: redirect('/cycle-ending-soon', status: 302), as: 'cycle_ending_soon_root'
    get '/cycle-ending-soon', to: 'pages#cycle_ending_soon'
    scope module: 'result_filters', path: '/start' do
      get 'location', to: 'location#start', as: 'start_location'
    end
  else
    get '/cycle-ending-soon', to: redirect('/', status: 301)
    # During the cycle there is no need for a separate path for
    # start#location but this was the root path in the
    # legacy c# app so we're redirecting to root
    get '/start/location', to: redirect('/', status: '301')
  end

  scope module: 'result_filters' do
    root to: 'location#start'
  end

  scope module: 'result_filters', path: '/start' do
    get 'subject', to: 'subject#start', as: 'start_subject'
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

  get '/provider-suggestions', to: 'provider_suggestions#index'
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
