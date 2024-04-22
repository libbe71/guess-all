# config/initializers/global_exception_handler.rb
class GlobalExceptionHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => exception
      # Log the exception or perform any other necessary actions
      Rails.logger.error "Unhandled error occurred: #{exception.message}"

      # Render a generic error page or response
      redirect_to "/#{current_locale}/auth"
    end
  end
end

Rails.application.config.middleware.insert_before Rack::Runtime, GlobalExceptionHandler
