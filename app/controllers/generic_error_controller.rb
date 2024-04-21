class GenericErrorController < ApplicationController
  before_action :clean_facebook_omniauth_fragment
  
    def index
        begin
            message = "An error occurred, you have been redirect to homepage"
            flash[:error] = message
            redirect_to "/"
        end
    end

  private

    def clean_facebook_omniauth_fragment
        if request.fullpath.include?('#_=_')
            redirect_to request.fullpath.split('#').first, status: :moved_permanently
        end
    end

end
