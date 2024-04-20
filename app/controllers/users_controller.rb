class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

def create
  @user = User.new(user_params)
  if @user.save
    flash[:notice] = "Registration succesfull."
    redirect_to @user
  else
    flash[:error] = 'Registration failed. Please try again.'
     puts '//////////////////////////////////////'
     puts @user.errors.full_messages
     puts '//////////////////////////////////////'
    redirect_to '/auth'
  end
end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end 
  end
  def check_username_availability
    username = params[:username]
    user = User.where('lower(username) = ?', username.downcase).first
    render json: { available: user.nil? }
  end
    
  private
  # Only allow a list of trusted parameters through.
  def user_params
      params.require(:user).permit(:username, :email_address, :password)
  end
end
