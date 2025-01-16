class UsersController < ApplicationController  
  before_action :authorize_user!, only: [:show] #new, :create, :check_username_availability, :moderator, :admin
  before_action :authorize_moderator!, only: [:moderator]
  before_action :authorize_admin!, only: [:admin, :new_moderator, :create_moderator, :delete_moderator, :search_moderators, :fetch_moderators]
  before_action :authorize_all!, only: [:settings, :profile, :edit, :update, :save_settings]
  def index
    @users = User.all

    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def admin
    @current_user = User.find(params[:id])

    if moderator_search_params[:search_query].present?
      search_query = moderator_search_params[:search_query]
      @moderators = search_moderators(search_query).where(role: "moderator")
    else
      @moderators = User.all.where(role: "moderator")
    end


    @moderators = @moderators&.paginate(page: 1, per_page: 10)
    rescue => e
      message = e.message 
      flash[:error] = message
      redirect_to "/#{@current_locale || "it"}/auth"
  end

  def create_moderator
  end

  def delete_moderator
    moderator_id = moderator_send_params[:moderator_id]
    moderator = User.find_by(id: moderator_id, role: "moderator")

    if moderator&.destroy
      flash[:notice] = "Moderator deleted"
    else
      flash[:error] = "Error deleting moderator"
    end
  end

  def search_moderators
    if moderator_search_params[:search_query].present?
      search_query = moderator_search_params[:search_query]
      moderators = fetch_moderators(search_query)

      moderators = moderators&.paginate(page: 1, per_page: 10)
      render json: moderators
    else 
      moderators = User.where(role:"moderator")
      render json: moderators
    end
  end

  def fetch_moderators(search_query)
    search_query = "%#{search_query}%"
  
    # Fetch users excluding the current user and their friends
    moderators = User.where('username LIKE :search OR email_address LIKE :search', search: search_query)
                .where(role: "moderator")
                .distinct
  
    return moderators
  end

  def new_moderator
    user = User.new(username: user_create_params[:username], email_address: user_create_params[:email_address], password: user_create_params[:password], locale: @current_locale, twitter_id: user_create_params[:twitter_id] || nil, role: "moderator")
    save = user.save;
    if save
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
  
  def moderator
    @current_user = User.find(params[:id])
    @games = Game.all

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
  user = User.new(username: user_create_params[:username], email_address: user_create_params[:email_address], password: user_create_params[:password], locale: @current_locale, twitter_id: user_create_params[:twitter_id] || nil, role: "user")
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
    params.require(:user).permit(:username, :email_address, :password)
  end

  def moderator_search_params
    params.permit(:id, :locale, :search_query)
  end
  def moderator_send_params
   params.require(:user).permit(:moderator_id)
  end

  #basic resctrict actions
  def require_login
    unless @current_user
      flash[:error] = "You must be logged in to access this page"
      redirect_to "/#{@current_locale || "it"}/auth"
    end
  end
end
