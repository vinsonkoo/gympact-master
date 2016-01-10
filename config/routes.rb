Rails.application.routes.draw do

  get 'payments/index'

  get 'payments/new'

  get 'payments/show'

  # USERS ##########################################################################################
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  

  # STATIC PAGES ###################################################################################
  root :to                      => 'pages#home'
  get 'happybirthday'           => 'pages#happybirthday'


  # PACT ###########################################################################################
  get 'pacts/:id/add_users'       => 'pacts#add_users',     as: "add_users"
  get 'pacts/:id/add_goals'       => 'pacts#add_goals',     as: "add_goals"
  get 'pacts/:id/add_penalties'   => 'pacts#add_penalties', as: "add_penalties"
  post 'pacts/:id/import'          => 'pacts#import',        as: "import"
  resources :pacts do
    collection do
      get ':pact_id/import/', action: :import
      post :import

    end
    # resources :chat
    resources :penalties
    resources :goals
    resources :weeks
  end
  get 'pacts/:pact_id/users'                => 'pacts#users',   as: 'pact_users'
  get 'pacts/:pact_id/chat'                 => 'pacts#chat',     as: 'pact_chat'
  get 'pacts/:pact_id/chat/week/:week_id'   => 'pacts#chat',     as: 'pact_chat_week'

  # get 'week/:pact_id'                 => 'week#show',     as: 'week'       # week_id for pact_id
  # get 'week/:pact_id/:week_id'        => 'week#show',     as: 'week_week'       # week_id for pact_id
  # get 'email/:pact_id/'               => 'week#email',    as: 'email' # week_id for pact_id



  # OTHER MODELS ###################################################################################
  # get 'messages/:id/is_workout'   => 'messages#is_workout', as: "is_workout"
  resources :messages do
    collection do
      get ':id/is_workout', action: :is_workout
      get 'import/new', action: :new_import # import_new_chats_path (?)
      post :import
    end
  end
  
  resources :users

  get 'workouts/:id/copy'   => 'workouts#copy', as: "copy"
  resources :workouts


  # get "pages/home"

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


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
