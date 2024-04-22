class GenericErrorController < ApplicationController
    def index
        begin
            current_locale = I18n.locale || I18n.default_locale
            message = "An error occurred, you have been redirect to homepage"
            flash[:error] = message
            redirect_to "/#{current_locale}/"
        end
    end
end
