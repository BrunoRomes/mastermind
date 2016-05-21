require "singleton"
class GuessInteractor
  include Singleton

  def create(player, game, fields)
    Game.transaction do
      validate_play game, player
      fields[:player] = player
      fields[:game] = game
      fields[:code].upcase!
      guess = Guess.new(fields)
      guess.calculate_result!(game.code)
      guess.save! rescue raise ValidationError.new (guess.errors)
      
      game.finish(player.name) if guess.correct?
      game.increase_turn unless guess.correct?
      game.save!
      guess
    end
  end

  private
    def validate_play(game, player)
      raise GameNotStartedError.new if game.waiting_for_players_to_join?
      raise GameEndedError.new if game.finished?
      raise AlreadyGuessedError.new if player.guessed_this_turn?(game.current_turn)
    end

end