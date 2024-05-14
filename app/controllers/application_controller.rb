class ApplicationController < ActionController::Base
    before_action :set_current_user
        rescue_from StandardError, with: :handle_exception
    around_action :switch_locale
    def handle_exception(exception)
        # Handle the exception here
        Rails.logger.error(exception.message)
        render plain: `An error occurred #{exception.message}`, status: :internal_server_error
    end

    def error
        render :error
    end

    def switch_locale(&action)
        set_current_locale
        locale = params[:locale] || I18n.default_locale
        I18n.with_locale(locale, &action)
    end

    private
    def set_current_user
        if session[:user_id]
            @current_user = User.find_by(id: session[:user_id])
        end
        @current_user ||= nil
    end

    def set_current_locale
        @current_locale = I18n.locale || I18n.default_locale
    end
end
