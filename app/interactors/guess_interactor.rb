require "singleton"
class GuessInteractor
  include Singleton

  def create(player, game, fields)
    Game.transaction do
      validate_play game, player
      update_fields game, player, fields
      guess = Guess.new(fields)
      guess.calculate_result!(game.code)
      guess.save! rescue raise ValidationError.new (guess.errors)
      update_game game, player, guess
      guess
    end
  end

  private
    def validate_play(game, player)
      raise GameNotStartedError.new if game.waiting_for_players_to_join?
      raise GameEndedError.new if game.finished?
      raise AlreadyGuessedError.new if player.guessed_this_turn?(game.current_turn)
    end

    def update_fields(game, player, fields)
      fields[:player] = player
      fields[:game] = game
      fields[:code].upcase!
    end

    def update_game(game, player, guess)
      if(guess.correct?)
        game.finish(player.name)
      else
        game.increase_turn
        game.force_finish if game.game_ended?
      end
      game.save!
    end

end