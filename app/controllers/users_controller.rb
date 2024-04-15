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
      redirect_to @user
    else
      message = "Invalid email or password"
      flash[:error] = message
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
    
  private
  # Only allow a list of trusted parameters through.
  def user_params
      params.require(:user).permit(:username, :name, :surname, :birthdate, :phone_number, :email_address, :password)
  end
end
