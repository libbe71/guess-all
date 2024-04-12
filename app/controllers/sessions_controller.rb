require 'jwt'
require 'securerandom'

class SessionsController < ApplicationController
     skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    def create
        user = User.find_by(email_address: session_params[:email])

        if user&.authenticate(session_params[:password])
            session[:user_id] = user.id
            redirect_to user_path(user)
        else
            message = "Invalid email or password"
            flash[:error] = message
            redirect_to login_path
        end
    end

    private
    def session_params
        params.require(:session).permit(:email, :password)
    end