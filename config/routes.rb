Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'reports#index'

  get 'sign_in' => 'sessions#new'
  delete 'sign_out' => 'sessions#destroy'

  resources :sessions, only: [:index, :create, :destroy]
  resources :verboice_callbacks, only: [:index]
  resources :dashboards, only: [:index]

  resources :places do
    collection do
      get 'ods_list'
      get 'download_template'
      post 'confirm_upload_location'
      post 'upload_location'
      get 'import'
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
  get 'project_variables' => 'settings#project_variables'
  get 'external' => 'settings#external'

  get '/steps/manifest' => 'steps#manifest', defaults: { format: :xml }
  post '/steps/validate_hc_worker' => 'steps#validate_hc_worker'

  resources :reports, only: [:index, :destroy] do
    member do
      put :toggle_status
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

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
