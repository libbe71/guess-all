module UsersHelper
    def check_username_availability
        username = params[:username]
        current_user = User.find_by(id: session[:user_id]) if session[:user_id]
        user = User.where('lower(username) = ?', username.downcase).first

        ret = !!(user.nil? || (current_user && user.id === current_user.id))
        render json: { available: ret  }

        rescue => e
        message = e.message 
        flash[:error] = message
        redirect_to "/#{@current_locale || "it"}/auth"
    end
end
