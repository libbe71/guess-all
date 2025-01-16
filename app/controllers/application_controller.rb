class ApplicationController < ActionController::Base
  before_action :set_current_user 
  around_action :switch_locale

  def error
    render :error
  end

  def switch_locale(&action)
    set_current_locale
    locale = params[:locale] || @current_user&.locale || session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end





  # General method to ensure the logged-in user matches the user from the URL
   private

  def authorize_user!
    user_id = params[:id] # Use snake_case for variables in Ruby
    if user_id.nil? || @current_user.nil? || @current_user.id != user_id.to_i || @current_user.role != "user"
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def authorize_moderator!
    user_id = params[:id] # Use snake_case for variables in Ruby
    if user_id.nil? || @current_user.nil? || @current_user.id != user_id.to_i || @current_user.role != "moderator"
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def authorize_admin!
    user_id = params[:id] # Use snake_case for variables in Ruby
    if user_id.nil? || @current_user.nil? || @current_user.id != user_id.to_i || @current_user.role != "admin"
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def authorize_all!
    user_id = params[:id] # Use snake_case for variables in Ruby
    if user_id.nil? || @current_user.nil? || @current_user.id != user_id.to_i
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end


  def set_current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
    @current_user ||= nil
  end

  def set_current_locale
    if params[:locale]
      I18n.locale = params[:locale]
      session[:locale] = I18n.locale # Save locale to session
      if @current_user
        @current_user.update(locale: I18n.locale) # Optionally save locale to the user if logged in
      end
    else
      I18n.locale = session[:locale] || I18n.default_locale
    end
    @current_locale = I18n.locale
  end
end
