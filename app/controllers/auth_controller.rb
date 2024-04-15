class AuthController < ApplicationController
  def create_session
    user = User.find_by(email_address: auth_params[:email])

    if user&.authenticate(auth_params[:password])
        session[:user_id] = user.id
        redirect_to "/users/#{user.id}"
    else
        message = "Invalid email or password"
        flash[:error] = message
        redirect_to '/auth'
    end
  end

  def auth_params
      params.require(:auth).permit(:email, :password)
  end
end
