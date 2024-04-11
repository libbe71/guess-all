require 'jwt'
require 'securerandom'

class SessionsController < ApplicationController
     skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    def create
        user = User.find_by(email_address: session_params[:email])

        if request.format.html? && user&.authenticate(session_params[:password])
            session[:user_id] = user.id
            redirect_to user_path(user)
        elsif request.format.json? && user&.authenticate(session_params[:password])
            tokens = create_tokens(user.id, session_params[:email], session_params[:password])
            render json: tokens
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
    
    def get_token_from_refresh
        refresh_token = refresh_params[:refresh_token]
        #JWT.decode(token, token = JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256'), true, algorithm: 'HS256')
        if refresh_token
            decoded_token = JWT.decode(refresh_token,  Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
            if(Time.current.to_i < decoded_token.first["exp"])
                tokens = create_tokens(decoded_token.first["user_id"], decoded_token.first["user_email"], decoded_token.first["user_password"])
                render json: tokens
            else
                message = "Refresh token expired"
                render json: { error: message }, status: :bad_request
            end
        else 
            message = "Refresh token not provided"
            render json: { error: message }, status: :bad_request
        end

        rescue =>  e
            respond_to do |format|
                format.html { redirect_to login_or_register_path, alert: "An error occurred: #{e.message}" }
                format.json { render json: { error: "An error occurred: #{e.message}" }, status: :not_found }
        end

    end

    private
    def session_params
        params.require(:session).permit(:email, :password)
    end

    def refresh_params
        params.require(:session).permit(:refresh_token)
    end


    def create_tokens(user_id, user_email, user_password)
        exp = Time.current.to_i + 4 * 60; #set expiration to 4 minutes
        payload = { user_id: user_id, user_email: user_email, exp: exp}
        token = JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')

        refresh_token_exp = Time.current.to_i + 60 * 60
        refresh_token_payload = {user_id: user_id, user_email: user_email, user_password:  user_password, exp: refresh_token_exp}
        refresh_token = JWT.encode(refresh_token_payload, Rails.application.credentials.secret_key_base, 'HS256')

        return {token: token, refresh_token: refresh_token}

    end

end

=begin
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
            token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base, 'HS256')
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