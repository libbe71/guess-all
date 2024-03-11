class SessionsController < ApplicationController
    def create
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
end
