require 'sidekiq/web'

Rails.application.routes.draw do
  
  root to: 'pages#home'

  #For Shopify
  # controller :sessions do
  #   get 'login'                 => :new,     :as => :login
  #   post 'login'                => :create,  :as => :authenticate
  #   get 'auth/shopify/callback' => :callback
  #   get 'logout'                => :destroy, :as => :logout
  # end 

  #Admin
  devise_for :admins
  get 'admin_dashboard' => 'pages#admin_dashboard'

  #Shoppers
  devise_for :shoppers, skip: [:sessions], controllers: {omniauth_callbacks: "shoppers/omniauth_callbacks"}
  get 'new_shopper_session' => 'pages#denied_request'


  #Brand
  devise_for :brands
  resources :leads
  get 'dashboard' => 'pages#dashboard'
  get 'settings'  => 'pages#home'
  

  #Instagram
  # match "facebook/subscription", :controller => :facebook, :action => :subscription, :as => 'facebook_subscription', :via => [:get,:post]
    match "callbacks/post", controller: :callbacks, action: :post, as: 'callbacks_post', via: [:get,:post]

    # post 'omniauth_callbacks/post'
    # get  'omniauth_callbacks/post' => 'omniauth_callbacks#challenge'

  #public pages
  get 'benefits'                     => 'pages#benefits'
  get 'payment_model'                => 'pages#payment_model'
  get 'platforms'                    => 'pages#platforms'
  get 'blog'                         => 'pages#home'
  get 'faq'                          => 'pages#faq'
  get 'terms_of_service'             => 'pages#terms_of_service'
  get 'privacy_policy'               => 'pages#privacy_policy'
  get 'thank_you'                    => 'pages#thank_you' #after lead sign up
  get 'shopper_sign_up'              => 'pages#shopper_sign_up'
  post 'pre_signup'                  => 'pages#shopper_signup_email' #will reroute to thank_you_shopper
  get 'thank_you_shopper'            => 'pages#thank_you_shopper'
  get 'thank_you_authorized_shopper' => 'pages#thank_you_authorized_shopper'
  get 'denied_request'               => 'pages#denied_request'

  # Sidekick
  mount Sidekiq::Web => '/sidekiq'

  get '*path' => redirect('/')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
