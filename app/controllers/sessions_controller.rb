require 'jwt'

class SessionsController < ApplicationController
     skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    def create
        user = User.find_by(email_address: session_params[:email])

        if request.format.html? && user&.authenticate(session_params[:password])
            session[:user_id] = user.id
            redirect_to user_path(user)
        elsif request.format.json? && user&.authenticate(session_params[:password])
            payload = { user_id: user.id, user_email: user.email_address}
            token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
            render json: { token: token }
        else
            message = "Invalid email or password"
            if request.format.html?
                flash[:error] = message
                redirect_to login_path
            elsif request.format.json?
                render json: { error: message }, status: :not_found
            end
        end
        rescue => e
        respond_to do |format|
            format.html { redirect_to login_or_register_path, alert: "An error occurred: #{e.message}" }
            format.json { render json: { error: "An error occurred: #{e.message}" }, status: :not_found }
        end
    end

    private
    def session_params
        params.require(:session).permit(:email, :password)
    end
end

=begin
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
            token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
            render json: { token: token }
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
=end
=begin
        @user = User. find_by(username: params [:username])
        #authenticate user credentials
        if !!@user && @user.authenticate(params [:password])
            redtrect on succes
            session[:user_id] = @user. id redirect_to user_path
        else #error message on fari
            message = "Something went wrong! Make sure your username and password are
            redirect_to login_path, notice: message"
        end
    end
=end