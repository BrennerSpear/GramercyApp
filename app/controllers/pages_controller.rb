class PagesController < ApplicationController
  before_action :authenticate_brand!, only: [:dashboard, :test]

  def home
    if current_brand
      redirect_to dashboard_path
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

  def test
    @brands = Brand.all
  end

  def settings
  end

  def dashboard
    @brand = current_brand
  end

end
