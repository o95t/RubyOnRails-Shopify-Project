ShopifyAramex::Application.routes.draw do

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'auth/shopify/callback' => :show
    delete 'logout' => :destroy
  end

  root :to => 'home#index'

  resources :users
  get 'update-shopify-info', to: "users#update_shopify_info", as: "update_shopify_info"
  get 'users/default_domestic_product/json', to: 'users#default_domestic_product', as: "default_domestic_product"
  get 'users/default_express_product/json', to: 'users#default_express_product', as: "default_express_product"
  get 'users/default_domestic_services/json', to: 'users#default_domestic_services', as: "default_domestic_services"
  get 'users/default_express_services/json', to: 'users#default_express_services', as: "default_express_services"

  resources :shipments
  get 'select_shipment_type', to: "shipments#select_shipment_type", as: "select_shipment_type"
  get 'print-label/:shipment_store_id', to: "shipments#print_label", as: "print_label"
  get 'order_by_number', to: "shipments#search_by_order_number", as: "order_by_number"
  
  resources :pickups, only: [:index, :new, :create] 
  get 'pickups/aramex_country_code/', to: 'pickups#aramex_country_code', as: "aramex_country_code"
  # get 'pickups/aramex_country_ar/', to: 'pickups#aramex_country_ar', as: "aramex_country_ar"
  get 'pickups/aramex_address_validate/json', to: 'pickups#aramex_address_validate', as: "aramex_address_validate"
  get 'pickups/aramex_country_city/json', to: 'pickups#aramex_country_city',  as: "aramex_country_city"
  ### Imran Code ###

  # resources :pickups, only: [:new, :create] do
  #   get :autocomplete_country_name, :on => :collection
  # end

  ### End ###
  
  get 'track/:shipment_store_id', to: "trackings#show", as: "track_shipment"
  get 'tracks', to: "trackings#index", as: "tracks"

  get 'rate-calculator/select-shipment-type', to: "rate_calculator#select_shipment_type", as: "rate_calculator_shipment_type"
  get 'rate-calculator/new', to: "rate_calculator#new", as: "new_rate_calculator"
  post 'rate-calculator/post', to: "rate_calculator#create", as: "post_rate_calculator"

  get 'orders', to: "orders#show"

  get 'search-by-order-number', to: "orders#search_by_order_number"
  get 'search-by-awb', to: "orders#search_by_awb"
  get 'search-by-fullfil', to: "orders#search_by_fullfil"


  
  post 'checkout', to: "checkout#start", as: "checkout"
  post 'webhook', to: "webhook#start", as: "webhook"

  post 'webhook-customers-redact', to: "webhookcustomersredact#start", as: "webhookcustomersredact"
  post 'webhook-shop-redact', to: "webhookshopredact#start", as: "webhookshopredact"
  post 'webhook-customers-data-request', to: "webhookcustomersdatarequest#start", as: "webhookcustomersdatarequest"

  get 'serchautocity', to: "serchautocity#start", as: "serchautocity"
  post 'apilocationvalidator', to: "apilocationvalidator#start", as: "apilocationvalidator"
  get "pages/new" => "new#show"
  get "pages/support" => "support#show"
  get "pages/manual" => "manual#show"
  #get 'checkout/:request', to: "checkout#start", as: "checkoutget"
  get "rules" => "rules#show"
  

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
#== Route Map
# Generated on 04 Jul 2013 14:36
#
#                               POST   /login(.:format)                                sessions#create
#         auth_shopify_callback GET    /auth/shopify/callback(.:format)                sessions#show
#                        logout DELETE /logout(.:format)                               sessions#destroy
#                          root        /                                               home#index
#                         users GET    /users(.:format)                                users#index
#                               POST   /users(.:format)                                users#create
#                      new_user GET    /users/new(.:format)                            users#new
#                     edit_user GET    /users/:id/edit(.:format)                       users#edit
#                          user GET    /users/:id(.:format)                            users#show
#                               PUT    /users/:id(.:format)                            users#update
#                               DELETE /users/:id(.:format)                            users#destroy
#                     shipments GET    /shipments(.:format)                            shipments#index
#                               POST   /shipments(.:format)                            shipments#create
#                  new_shipment GET    /shipments/new(.:format)                        shipments#new
#                 edit_shipment GET    /shipments/:id/edit(.:format)                   shipments#edit
#                      shipment GET    /shipments/:id(.:format)                        shipments#show
#                               PUT    /shipments/:id(.:format)                        shipments#update
#                               DELETE /shipments/:id(.:format)                        shipments#destroy
#          select_shipment_type GET    /select_shipment_type(.:format)                 shipments#select_shipment_type
#                   print_label GET    /print-label/:order_id(.:format)                shipments#print_label
#                       pickups GET    /pickups(.:format)                              pickups#index
#                       pickups POST   /pickups(.:format)                              pickups#create
#                    new_pickup GET    /pickups/new(.:format)                          pickups#new
#                track_shipment GET    /track/:order_id(.:format)                      trackings#show
# rate_calculator_shipment_type GET    /rate-calculator/select-shipment-type(.:format) rate_calculator#select_shipment_type
#           new_rate_calculator GET    /rate-calculator/new(.:format)                  rate_calculator#new
#          post_rate_calculator POST   /rate-calculator/post(.:format)                 rate_calculator#create
#                        orders GET    /orders(.:format)                               orders#show
