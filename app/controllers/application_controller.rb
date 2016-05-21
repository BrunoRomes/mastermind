class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ValidationError, with: :validation_error
  rescue_from CannotJoinError, with: :cannot_join_error

  private

    def validation_error(e)
      @error_messages = e.errors
      render "validation_error.json", status: :unprocessable_entity
    end

    def cannot_join_error
      respond_to do |format|
        format.json { head :forbidden }
      end
    end

end
