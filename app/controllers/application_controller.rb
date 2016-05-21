class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ValidationError, with: :validation_error
  rescue_from CannotJoinError, with: :cannot_join_error
  rescue_from NotFoundError, with: :not_found_error
  rescue_from GameNotStartedError, with: :game_not_started_error
  rescue_from GameEndedError, with: :game_ended_error
  rescue_from AlreadyGuessedError, with: :already_guessed_error

  private

    def validation_error(e)
      @error_messages = e.errors.to_hash
      render "validation_error.json", status: :unprocessable_entity
    end

    def game_not_started_error
      @error_messages = {game: ["has not started yet"]}
      render "validation_error.json", status: :unprocessable_entity
    end

    def game_ended_error
      @error_messages = {game: ["has already ended"]}
      render "validation_error.json", status: :unprocessable_entity
    end

    def already_guessed_error
      @error_messages = {guess: ["has already been sent this turn. Please wait for the other players to play in this turn"]}
      render "validation_error.json", status: :unprocessable_entity
    end

    def not_found_error
      respond_to do |format|
        format.any(:json,:xml,:html) { head :not_found }
      end
    end

    def cannot_join_error
      respond_to do |format|
        format.json { head :forbidden }
      end
    end

end
