class AuthController < ApplicationController
  def login_or_register
    if logged_in?
      # User is logged in
      # You can redirect them to another page or render a different view
      redirect_to "/user/#{current_user["id"]}"
    end
  end
  def create_session
    identifier = auth_params[:identifier].downcase
    user = User.where("LOWER(email_address) = ? OR LOWER(username) = ?", identifier, identifier).first

    if user&.authenticate(auth_params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Login succesfull"
      redirect_to "/users/#{user.id}"
    else
      message = "Invalid email/username or password"
      flash[:error] = message
      redirect_to '/auth'
    end
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
