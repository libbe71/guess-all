class AuthController < ApplicationController
  def login_or_register
    if logged_in?
      current_locale = I18n.locale || I18n.default_locale
      # User is logged in
      # You can redirect them to another page or render a different view
      redirect_to "/#{current_locale}/user/#{current_user["id"]}"
    end
    rescue => e
      message = e.message
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end
  def create_session
    identifier = auth_params[:identifier].downcase
    user = User.where("LOWER(email_address) = ? OR LOWER(username) = ?", identifier, identifier).first
    current_locale = I18n.locale || I18n.default_locale

    if user&.authenticate(auth_params[:password])
      session[:user_id] = user.id
      current_locale =  user&.locale || I18n.locale || I18n.default_locale
      I18n.locale = current_locale
      flash[:notice] = t('snackbar.loginSuccess')
      redirect_to "/#{current_locale}/user/#{user.id}"
    else
      raise AuthError, t('snackbar.loginError')
    end
    rescue => e
      message = e.message
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
      
  end

  def destroy_session
    session[:user_id] = nil
    flash[:notice] = t('snackbar.logoutSuccess')
    redirect_to root_path
  end


  private

  def auth_params
    params.require(:auth).permit(:identifier, :password)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end
end
