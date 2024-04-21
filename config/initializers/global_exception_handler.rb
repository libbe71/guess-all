# config/initializers/global_exception_handler.rb
class GlobalExceptionHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
        rescue => e
        # Log other unexpected errors
        Rails.logger.error "Unhandled error occurred: #{e.message}"

        # Render a generic error page or response

        [301, {'Location' => "/error"}, []]
        #[500, { 'Content-Type' => 'text/plain' }, ['An unexpected error occurred']]
  end
end

Rails.application.config.middleware.use GlobalExceptionHandler
