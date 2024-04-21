class ApplicationController < ActionController::Base

  rescue_from StandardError, with: :handle_exception

  def handle_exception(exception)
    # Handle the exception here
    Rails.logger.error(exception.message)
    render plain: 'An error occurred', status: :internal_server_error
  end
end
