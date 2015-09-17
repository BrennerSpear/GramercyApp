require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'pages#home'

  #Admins
  devise_for :admins
  get 'admin_dashboard' => 'admins#admin_dashboard'

  #Shoppers
  devise_for :shoppers
  get 'new_shopper_session' => 'pages#denied_request'


  #Brands
  devise_for :brands
  resources :leads
  get 'load'                 => 'bigcommerce_callbacks#load'
  post 'webhook'             => 'bigcommerce_callbacks#webhook'
  get 'instagram_auth'       => 'brands#instagram_auth'
  get 'initial_settings'     => 'brands#initial_settings'
  post 'initialize_settings' => 'brands#initialize_settings'
  get 'set_up_stripe'        => 'brands#set_up_stripe'
  post 'send_stripe_info'    => 'brands#send_stripe_info'
  get 'dashboard'            => 'brands#dashboard'
  get 'dashboard_test'       => 'brands#dashboard_test'


  #Oauth instagram & Bigcommerce
  get "/auth/instagram/callback"   => 'instagram_callbacks#instagram'
  get "/auth/bigcommerce/callback" => "bigcommerce_callbacks#bigcommerce"

  #subscription to Shoppers' instagrams
  get  "instagram/receive_post" => 'instagram_callbacks#challenge'
  post "instagram/receive_post" => 'instagram_callbacks#receive_post'

  #subscription to Brands' orders
  post "bigcommerce/receive_order" => 'bigcommerce_callbacks#receive_order'

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
