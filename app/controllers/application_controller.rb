class ApplicationController < ActionController::Base

    rescue_from StandardError, with: :handle_exception

    def handle_exception(exception)
    # Handle the exception here
    Rails.logger.error(exception.message)
    render plain: 'An error occurred', status: :internal_server_error
    end


    around_action :switch_locale

    def switch_locale(&action)
        locale = params[:locale] || I18n.default_locale
        I18n.with_locale(locale, &action)
    end

    def default_url_options
        { locale: I18n.locale }
    end
end
