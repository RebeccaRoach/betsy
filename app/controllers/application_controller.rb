class ApplicationController < ActionController::Base
  before_action :set_categories

  def set_categories
    @categories = Category.all
  end

  def current_user
    @current_user = Merchant.find_by(id: session[:uid])
  end

  def require_login
    if current_user.nil?
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)
    end
  end
end
