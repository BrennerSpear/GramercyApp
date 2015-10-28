require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'pages#home'

  #Admins
  devise_for :admins
  get 'admin_dashboard' => 'admins#admin_dashboard'
  get 'brands/:id'      => 'admins#show_brand', :as => 'brand'
  get 'admin_dash_shoppers' => 'admins#admin_dash_shoppers'
  get 'admin_dash_followers' => 'admins#admin_dash_followers'
  get 'admin_dash_brands' => 'admins#admin_dash_brands'
  get 'admin_dash_orders' => 'admins#admin_dash_orders'
  get 'admin_dash_posts' => 'admins#admin_dash_posts'

  #No signing in through regular browser - only via ecommerce platform
  get 'home'                 => 'pages#home'
  get 'denied_request'       => 'pages#denied_request'
  get '/shoppers/sign_in'    => 'pages#denied_request'
  get '/brands/sign_in'      => 'pages#home'
  get '/brands/sign_up'      => 'pages#home'
  get '/brands/password/new' => 'pages#home'

  #Shoppers
  devise_for :shoppers
  get 'new_shopper_session'          => 'pages#denied_request'
  get 'shopper_sign_up'              => 'shoppers#shopper_sign_up'
  post 'pre_signup'                  => 'shoppers#shopper_signup_email' #will reroute to thank_you_shopper
  get 'thank_you_shopper'            => 'shoppers#thank_you_shopper'
  get 'thank_you_authorized_shopper' => 'shoppers#thank_you_authorized_shopper'


  #Brands
  devise_for :brands
  get 'load'                 => 'bigcommerce_callbacks#load'
  post 'webhook'             => 'bigcommerce_callbacks#webhook'
  get 'instagram_auth'       => 'brands#instagram_auth'
  get 'initial_settings'     => 'brands#initial_settings'
  post 'initialize_settings' => 'brands#initialize_settings'
  get 'set_up_stripe'        => 'brands#set_up_stripe'
  post 'send_stripe_info'    => 'brands#send_stripe_info'
  get 'dashboard'            => 'brands#dashboard'
  get 'settings'             => 'brands#settings'
  post 'update_settings'     => 'brands#update_settings'

  #dashboard UJS
  get 'sort_dashboard'       => 'brands#sort_dashboard'
  get 'filter_dashboard'     => 'brands#filter_dashboard'


  #Oauth instagram & Bigcommerce
  get "/auth/instagram/callback"   => 'instagram_callbacks#instagram'
  get "/auth/bigcommerce/callback" => "bigcommerce_callbacks#bigcommerce"

  #subscription to Shoppers' instagrams
  get  "instagram/receive_post" => 'instagram_callbacks#challenge'
  post "instagram/receive_post" => 'instagram_callbacks#receive_post'

  #subscription to Brands' orders
  post "bigcommerce/receive_order" => 'bigcommerce_callbacks#receive_order'


  # Sidekick
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
    mount Sidekiq::Monitor::Engine => '/sidekiq-monitor'
  end

  get '*path' => redirect('/')

end
