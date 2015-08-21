require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'pages#home'

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
  # get 'test'                         => 'pages#test'

  # Sidekick
  mount Sidekiq::Web => '/sidekiq'
  mount Sidekiq::Monitor::Engine => '/sidekiq-monitor'

  get '*path' => redirect('/')

end
