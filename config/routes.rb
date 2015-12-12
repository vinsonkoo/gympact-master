Rails.application.routes.draw do

  get 'pact_users_controller/new'

  get 'pact_users_controller/create'

  get 'pact_users_controller/index'

  get 'pact_users_controller/show'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  
  resources :messages do
    collection do
      get 'import/new', action: :new_import # import_new_chats_path (?)
      post :import
    end
  end
  
  # resources :user
  get 'pacts/:id/add_users'      => 'pacts#add_users'
  # get 'pacts/pact_users'         => 'pacts#pact_users'
  get 'pacts/:id/add_penalty'      => 'pacts#add_penalty'
  get 'pacts/:id/add_goals'      => 'pacts#add_goals'
  resources :pacts do
    resources :penalties
    resources :goals
    resources :users
  end
  # resources :pacts, param: :pact_name # will want to eventually have path/to/pact_name instead of path/to/pact_id

  resources :penalties
  
  resources :week

  get 'workout_types/index'

  get 'workouts/index'

  resources :pact_user_relations
  # get ':pact_user_relations(/:new(/:id(.:format)))' => 'pact_user_relations#new'
  # get 'pact_user_relations/index'

  get 'messages/index'


  resources :goals


  # STATIC PAGES
  root :to                      => 'pages#home'
  get 'happybirthday'           => 'pages#happybirthday'


  # PACT PAGES
  get 'chat/:pact_id'                 => 'chat#show',     as: 'chat'       # Chat for pact_id
  get 'chat/:pact_id/:week_id'        => 'chat#show',     as: 'chat_week'  # Chat for pact_id

  get 'tracking/:pact_id'             => 'tracking#show', as: 'tracking'   # Tracking for pact_id

  # get 'week/:pact_id'                 => 'week#show',     as: 'week'       # week_id for pact_id
  # get 'week/:pact_id/:week_id'        => 'week#show',     as: 'week_week'       # week_id for pact_id
  get 'email/:pact_id/'               => 'week#email',    as: 'email' # week_id for pact_id
  get 'email/:pact_id/:week_id'       => 'week#email',    as: 'email_week' # week_id for pact_id









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
