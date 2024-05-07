class UsersController < ApplicationController
  def index
    @users = User.all

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  def show
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  def settings
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end
  def profile
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  def new
    @user = User.new

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

def create
  current_locale = I18n.locale || I18n.default_locale || "it"
  @user = User.new(username: user_create_params[:username], email_address: user_create_params[:email_address], password: user_create_params[:password], locale: current_locale, twitter_id: user_create_params[:twitter_id] || nil)
  save = @user.save;
  if save
    flash[:notice] = "#{t("snackbar.registerSuccess")}"
    redirect_to "/#{current_locale || "it"}/auth"
  else
    raise UsersError, "#{t("snackbar.registerError")}"
  end

  rescue => e
    message = e.message 
    flash[:error] = message
    redirect_to "/#{current_locale || "it"}/auth"
end

  def edit
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_update_params)
      current_locale = I18n.locale || I18n.default_locale || it
      redirect_to "/#{current_locale || "it"}/#{@user.id}"
    else
      raise UsersError, "#{t("snackbar.userUpdateError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  def change_locale
    @user = User.find(params[:id])
    if !@user.update(locale_params)
      raise UsersError, "#{t("snackbar.userChangeLocaleError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end
  def change_theme
    @user = User.find(params[:id])
    if !@user.update(theme_params)
      raise UsersError, "#{t("snackbar.userChangeThemeError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end


  def check_username_availability
    username = params[:username]
    current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    user = User.where('lower(username) = ?', username.downcase).first

    ret = !!(user.nil? || (current_user && user.id === current_user.id))
    render json: { available: ret  }

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  private
    
  # Only allow a list of trusted parameters through.
  def user_create_params
      params.require(:user).permit(:username, :email_address, :password, :twitter_id)
  end
  def locale_params
      params.require(:user).permit(:locale)
  end
  def theme_params
      params.require(:user).permit(:theme)
  end
  def user_update_params
    params.require(:user).permit(:username, :email_address, :password)
  end
end
