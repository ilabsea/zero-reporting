Rails.application.routes.draw do
  resources :events, only: [:index, :new, :create, :destroy]
  resources :event_attachments, only: [] do
    member do
      get :download
    end
  end

  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end

  mount Sidekiq::Web => '/sidekiq'

  root 'reports#index'

  get 'sign_in' => 'sessions#new'
  delete 'sign_out' => 'sessions#destroy'

  resources :sessions, only: [:index, :create, :destroy]
  resources :verboice_callbacks, only: [:index]
  resources :dashboards, only: [:index]
  resources :calendars, only: [:index]
  resources :weeks, only: [:index]
  resources :sms_recipients
  resources :places do
    collection do
      get 'ods_list'
      get 'download_template'
      post 'confirm_upload_location'
      post 'upload_location'
      get 'import'
      get 'download'
      get 'download_users'
    end
  end

  resources :users do
    collection do
      get 'profile'
      put 'change_profile'
      get 'download_template'
      post 'confirmed_upload_users'
      post 'upload_users'
      get 'by_place'
      get 'search'
      get 'import'
    end

    member do
      put 'reset'
    end
  end

  resources :settings, only: [:index]
  put 'update_settings' => 'settings#update_settings'

  put 'verboice' => 'settings#verboice'
  put 'hub' => 'settings#hub'
  get 'project_variables' => 'settings#project_variables'
  get 'external' => 'settings#external'

  get '/steps/manifest' => 'steps#manifest', defaults: { format: :xml }
  resources :steps do
    collection do
      post :validate_hc_worker
      post :send_sms
    end
  end

  resources :reports, only: [:index, :destroy] do
    member do
      put :toggle_status
      put :update_week
    end

    collection do
      get :export_as_csv
      get :query_piechart
    end
  end

  resources :report_variables, only: [] do
    member do
      get :play_audio
    end
  end

  resources :variables

  resources :channels do
    member do
      put 'state'
    end
  end

  resources :alerts do
    collection do
      get 'log'
    end
  end

  resources :external_sms_settings
  resources :hub_push_notifications, only: [:create]

  resources :sms_broadcasts, only: [:index, :create]

  namespace :api, defaults: {format: 'json'} do
    resources :places, only: [:index]
    namespace :hub do
      resources :reports, only: [:index, :show]
    end
  end

end
