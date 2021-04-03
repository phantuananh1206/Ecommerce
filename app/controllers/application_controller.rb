class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale, :load_categories, :set_search
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :phone_number, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def store_location
    if(request.path != '/orders' && !request.xhr? && !current_user)
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session.delete(:previous_url) || root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_categories
    @categories = Category.sort_name_categories_alphabetically.select(:id, :name)
  end

  def set_search
    @q = Product.ransack(params[:q])
  end
end
