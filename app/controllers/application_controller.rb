class ApplicationController < ActionController::Base
before_action :set_current_user
    rescue_from StandardError, with: :handle_exception

    def handle_exception(exception)
    # Handle the exception here
    Rails.logger.error(exception.message)
    render plain: `An error occurred #{exception.message}`, status: :internal_server_error
    end

    def error
        render :error
    end

    around_action :switch_locale

    def switch_locale(&action)
        locale = params[:locale] || I18n.default_locale
        I18n.with_locale(locale, &action)
    end

    def default_url_options
        { locale: I18n.locale }
    end
    private
    def set_current_user
        @current_user = User.find_by(id: session[:user_id]) || nil
    end
end
