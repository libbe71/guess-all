class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if request.format.html? && user&.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to user_path(user)
        elsif request.format.json? && user&.valid_password?(params[:password])
            token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
            render json: { token: token }
        else
            message = "Invalid email or password"
            if request.format.html?
                flash[:error] = message
                redirect_to login_path
            else
                render json: { error: message }, status: :unauthorized
            end
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
=end
    end

end
