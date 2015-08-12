class PagesController < ApplicationController
  before_action :authenticate_brand!, only: [:dashboard, :test]
  before_action :authenticate_admin!, only: [:admin_dashboard]

  def home
    if current_brand
      redirect_to dashboard_path
    elsif current_admin
      redirect_to admin_dashboard_path
    end
  end

  def benefits
  end

  def payment_model
  end

  def platforms
  end

  def blog
  end

  def faq
  end
  
  def terms_of_service
  end

  def privacy_policy
  end

  def thank_you
  end

  def settings
    @brand = current_brand
  end

  def dashboard
    @brand = current_brand
  end

  def admin_dashboard
    @leads = Lead.all
    @brands = Brand.all
    @shoppers = Shopper.all
  end

  def shopper_sign_up
  end

  def shopper_signup_email
    if Shopper.where(email: params[:email]).blank?

      ShopperMailer.prelaunch_signup(params[:email]).deliver_now
      redirect_to thank_you_shopper_path

    else
      redirect_to(:back)
      flash[:notice] = "You've already registered that email address to Gramercy"
    end
  end

end
