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
  @user = User.new(user_params)
  current_locale = I18n.locale || I18n.default_locale

  if user_update_params.twitter_id == ""
    user_update_params.twitter_id = nil;
  end
  if @user.save
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
      current_locale = I18n.locale || I18n.default_locale
      redirect_to "/#{current_locale || "it"}/#{@user.id}"
    else
      raise UsersError, "#{t("snackbar.userUpdateError")}"
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
    ret = (user.nil? || user.id === current_user.id)
    puts  current_user.id
    puts user.id
    render json: { available: ret  }

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale || "it"}/auth"
  end

  private
    
  # Only allow a list of trusted parameters through.
  def user_params
      params.require(:user).permit(:username, :email_address, :password, :twitter_id)
  end
  def user_update_params
    params.require(:user).permit(:username, :email_address, :password)
  end
end
