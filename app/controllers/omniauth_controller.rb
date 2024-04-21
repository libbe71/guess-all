class OmniauthController < ApplicationController
  def new
    render :new
  rescue OAuth::Unauthorized => e
    flash[:error] = "OAuth Unauthorized error: #{e.message}"
    redirect_to '/auth' # Redirect the user back to the authentication page
  rescue ActionController::InvalidAuthenticityToken => e
    flash[:error] = "Invalid authenticity token error: #{e.message}"
    redirect_to '/auth' # Redirect the user back to the authentication page
  end
  def create
    user_info = request&.env['omniauth.auth']
    if user_info
      user = User.find_by(email_address: user_info&.info&.email)
      if user
        session[:user_id] = user.id
        redirect_to "/users/#{user.id}"
      else
        @username = user_info&.info&.nickname || user_info&.info&.username || user_info&.info&.name || user_info&.info&.last_name || user_info&.info&.family_name || ""
        @email_address = user_info&.info&.email || ""
      end
    else
      flash[:notice] = "Something went wrong."
      redirect_to '/auth'
    end
  end
end
