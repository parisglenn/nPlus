NPlus::Application.routes.draw do
  resources :user_office_hours

  resources :feedbacks

  resources :round_up_matches, only: [:edit, :update]

  resources :round_up_match_users, only: [:update]

  resources :round_up_times

  #get "my_round_up_times" => "round_up_times#account_round_up_times", :as => "account_round_up_times"

  resources :create_round_up_times


  devise_for :users

  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up" #/users/sign_up Devise::RegistrationsController#new
  get "log_out" => "sessions#destroy", :as => "log_out"

  root :to => "home#index"
  resources :events

  #devise_for :users

  resources :users
  resources :interests
  resources :geos

  resources :subscriptions do
    collection do
        put 'update_subscriptions'
    end
  end
  get "my_interests" => "subscriptions#account_subscriptions", :as => "account_subscriptions"
  #match "/my_subscriptions", to: "subscriptions#account_subscriptions", via: get#, as: "account_subscriptions"
  #match '/users', to: 'profiles#index', via: 'get', as: 'users'

  devise_scope :user do 
    root to: 'static_pages#home'
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :user_geos do
    collection do
        put 'update_account_geos'
    end
  end
  get "my_geos" => "user_geos#account_geos", :as => "account_geos"

  resources :sessions

  resources :profiles do
    collection do
        put 'update_subscriptions'
        put 'update_account_geos'
        put 'update_round_up_times'
        put 'update_notification_frequencies'
    end
  end
  get "profile" => "profiles#define", as: "define_profile"
  get "admin_hub" => "admins#hub", as: "admin_hub"

  post "rsvps/create" => "rsvps#create", as: "create_rsvp"
  resources :rsvps
  put "rsvps/assign_host" => "rsvps#assign_host", as: "assign_host"

  resources :comments, only: [:create, :destroy]


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
