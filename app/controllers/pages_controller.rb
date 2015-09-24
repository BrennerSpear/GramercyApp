class PagesController < ApplicationController

  def home
    if current_brand
      # redirect_to dashboard_path
    elsif current_admin
      redirect_to admin_dashboard_path
    end
  end

end
