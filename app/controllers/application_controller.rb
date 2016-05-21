class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ValidationError, with: :validation_error

  private

    def validation_error(e)
      @error_messages = e.errors
      render "validation_error.json", status: :unprocessable_entity
    end

end
