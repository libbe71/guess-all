class UsersController < ApplicationController
  def index
    @users = User.all

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

  def show
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

  def new
    @user = User.new

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

def create
  @user = User.new(user_params)
  current_locale = I18n.locale || I18n.default_locale
  if @user.save
    flash[:notice] = "#{t("snackbar.registerSuccess")}"
    redirect_to "/#{current_locale}/auth"
  else
    raise UsersError, "#{t("snackbar.registerError")}"
  end

  rescue => e
    message = e.message 
    flash[:error] = message
    redirect_to "/#{current_locale}/auth"
end

  def edit
    @user = User.find(params[:id])

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      current_locale = I18n.locale || I18n.default_locale
      redirect_to "/#{current_locale}/#{@user}"
    else
      raise UsersError, "#{t("snackbar.userUpdateError")}"
    end

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

  def check_username_availability
    username = params[:username]
    user = User.where('lower(username) = ?', username.downcase).first
    render json: { available: user.nil? }

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{current_locale}/auth"
  end

  private
    
  # Only allow a list of trusted parameters through.
  def user_params
      params.require(:user).permit(:username, :email_address, :password, :twitter_id)
  end
end
