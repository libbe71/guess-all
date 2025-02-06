class AuthController < ApplicationController
  def login_or_register
    if user?
      redirect_to "/#{@current_locale}/user/#{@current_user["id"]}"
    elsif moderator?
      redirect_to "/#{@current_locale}/moderator/#{@current_user["id"]}"
    elsif admin?
      redirect_to "/#{@current_locale}/admin/#{@current_user["id"]}"
    end
  
    rescue => e
      message = e.message
      flash[:error] = message
      redirect_to "/#{@current_locale}/auth"
  end
  def create_session
    identifier = auth_params[:identifier].downcase

    user = User.where("LOWER(email_address) = ? OR LOWER(username) = ?", identifier, identifier).first
    if user&.authenticate(auth_params[:password])
      session[:user_id] = user.id
      if user&.locale
        @current_locale =  user&.locale
      end
      set_current_user
      I18n.locale = @current_locale
      if user?
        redirect_to "/#{@current_locale}/user/#{@current_user["id"]}"
      elsif moderator?
        redirect_to "/#{@current_locale}/moderator/#{@current_user["id"]}"
      elsif admin?
        redirect_to "/#{@current_locale}/admin/#{@current_user["id"]}"
      else 
        redirect_to "/#{@current_locale}/auth"
      end
    else
      raise AuthError, t('snackbar.loginError')
    end

    rescue => e
      message = e.message
      flash[:error] = message
      redirect_to "/#{@current_locale}/auth"


  end

  def destroy_session
    session[:user_id] = nil
    redirect_to root_path
  end
  

  private

  def auth_params
    params.require(:auth).permit(:identifier, :password)
  end

  def user?
    !!@current_user && @current_user.role == "user"
  end
  def moderator?
    !!@current_user && @current_user.role == "moderator"
  end
  def admin?
    !!@current_user && @current_user.role == "admin"
  end

end
