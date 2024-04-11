class OmniauthController < ApplicationController
  def new
    render :new
  end

  def create
    #email,user_birthday,user_gender,user_hometown'
    user_info = request.env['omniauth.auth']
    if(user_info)
      user_email = user_info["email"];
      user = User.find_by(email_address: user_email)
      #user exists so we have to log-in
      if(user)
        if(equest.format.html?)
          session[:user_id] = user.id
          redirect_to user_path(user)
        #elsif(equest.format.json?)
          #{render json: {ret: user_info}}
        end

      #user doesn't exist so we have to register
      else
        puts "error"
      end

    #didn't login on facebook
    else
        puts "error"
    end
  end
end
