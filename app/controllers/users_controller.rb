class UsersController < ApplicationController  
  before_action :authorize_user!, except: [:new, :create, :check_username_availability]
  def index
    @users = User.all

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def show
    @current_user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def settings
    @current_user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end
  def profile
    @current_user = User.find(params[:id])
    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def new
    @current_user = User.new

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

def create
  user = User.new(username: user_create_params[:username], email_address: user_create_params[:email_address], password: user_create_params[:password], locale: @current_locale, twitter_id: user_create_params[:twitter_id] || nil)
  save = user.save;
  if save
    @current_user = user
    flash[:notice] = "#{t("snackbar.registerSuccess")}"
    redirect_to "/#{@current_locale || "it"}/auth"
  else
    raise UsersError, "#{t("snackbar.registerError")}"
  end

  rescue => e
    message = e.message 
    flash[:error] = message
    redirect_to "/#{@current_locale || "it"}/auth"
end

  def edit
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_update_params)
      flash[:notice] = t('snackbar.editSuccess')
      redirect_to "/#{@current_locale || "it"}/#{@user.id}"
    else
      raise UsersError, "#{t("snackbar.userUpdateError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end
  def save_settings
    @user = User.find(params[:id])
    if !@user.update(settings_params)
      raise UsersError, "#{t("snackbar.userChangeThemeError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def check_username_availability
    username = params[:username]
    user = User.where('lower(username) = ?', username.downcase).first
    puts user 
    #user.nil? check if user in db; (current_user && user.id === current_user.id) check the current user isn't displayed as already taken (edit)
    ret = !!(user.nil? || (@current_user && user.id === @current_user.id))
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
  def settings_params
      params.require(:user).permit(:locale, :theme)
  end
  def user_update_params
    params.permit(:username, :email_address, :password)
  end

  #basic resctrict actions
  def require_login
    unless @current_user
      flash[:error] = "You must be logged in to access this page"
      redirect_to "/#{@current_locale || "it"}/auth"
    end
  end
end
