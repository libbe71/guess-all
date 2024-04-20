class AuthController < ApplicationController
  def create_session
    identifier = auth_params[:identifier].downcase
    user = User.where("LOWER(email_address) = ? OR LOWER(username) = ?", identifier, identifier).first

    if user&.authenticate(auth_params[:password])
      session[:user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      message = "Invalid email/username or password"
      flash[:error] = message
      redirect_to '/auth'
    end
  end

  def auth_params
    params.require(:auth).permit(:identifier, :password)
  end
end
