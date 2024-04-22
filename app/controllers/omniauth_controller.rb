class OmniauthController < ApplicationController
  before_action :set_current_locale

  def new
    render :new
    rescue => e
      flash[:error] = "#{e.message}"
      redirect_to auth_path(locale: @current_locale)
  end

  def create
    user_info = request&.env['omniauth.auth']

    if user_info
      @username = user_info&.info&.nickname || user_info&.info&.username || user_info&.info&.name || user_info&.info&.last_name || user_info&.info&.family_name || ""
      @email_address = user_info&.info&.email || ""
      provider = user_info&.provider
      case provider
        when 'twitter'
          @twitter_id = user_info&.uid
          if @twitter_id 
            user = User.find_by(twitter_id: @twitter_id)
          else
            raise OmniauthError, "#{t("snackbar.oAuthError")}"
          end
        else
          user = User.find_by(email_address: @email_address)
      end
      if user
        session[:user_id] = user.id
        redirect_to user_path(user, locale: @current_locale)
      end
    else
      raise OmniauthError, "#{t("snackbar.oAuthError")}"
    end
    rescue => e
      flash[:error] = "#{e.message}"
      redirect_to auth_path(locale: @current_locale)
  end

  private

  def set_current_locale
    @current_locale = I18n.locale || I18n.default_locale
  end
  
end
