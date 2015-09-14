require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'brands#initial_settings'

  #Admins
  devise_for :admins
  get 'admin_dashboard' => 'admins#admin_dashboard'

  #Shoppers
  devise_for :shoppers
  get 'new_shopper_session' => 'pages#denied_request'


  #Brands
  devise_for :brands
  resources :leads
  get 'load'             => 'callbacks#load'
  post 'webhook'         => 'callbacks#webhook'
  get 'dashboard'        => 'brands#dashboard'
  get 'dashboard_test'   => 'brands#dashboard_test'
  get 'instagram_auth'   => 'brands#instagram_auth'
  get 'initial_settings' => 'brands#initial_settings'
  post 'initialize_settings' => 'brands#initialize_settings'
  get 'set_up_stripe'     => 'brands#set_up_stripe'



  #Oauth routes for both shoppers & brands 
  get "/auth/:action/callback" => "callbacks", constraints: {action: /instagram|bigcommerce/}

  #Instagram subscriptions
  match "callbacks/post", controller: :callbacks, action: :post, as: 'callbacks_post', via: [:get,:post]

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
  mount Sidekiq::Monitor::Engine => '/sidekiq-monitor'

  get '*path' => redirect('/')

end
