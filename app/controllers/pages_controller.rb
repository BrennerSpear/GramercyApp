class PagesController < ApplicationController
  before_action :authenticate_brand!, only: [:dashboard]
  before_action :authenticate_admin!, only: [:admin_dashboard]

  def home
    if current_brand
      redirect_to dashboard_path
    elsif current_admin
      redirect_to admin_dashboard_path
    end
  end

  # def settings
  #   @brand = current_brand
  # end

  def dashboard
    @brand = current_brand
  end

  def admin_dashboard
    @leads        = Lead.all
    @brands       = Brand.all
    @shops        = Shop.all
    @shoppers     = Shopper.all
    @orders       = Order.all
    @posts        = Post.all
    @rewards      = Reward.all
    @followers    = Follower.all
    @followed_bys = FollowedBy.all

  end

  def shopper_sign_up
  end

  def shopper_signup_email
    if Shopper.where(email: params[:email]).blank?

      ShopperMailer.delay.prelaunch_signup(params[:email])
      redirect_to thank_you_shopper_path

    else
      redirect_to(:back)
      flash[:notice] = "You've already registered that email address to Gramercy"
    end
  end


  # def test

  #   post = Post.find(10)
  #   ExpirePostWorker.perform_in(Rails.configuration.expire_time, post.id)
  # end

end
