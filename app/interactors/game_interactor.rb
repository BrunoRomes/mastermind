require "singleton"
class GameInteractor
  include Singleton

  def all_available
    Game.find_availables
  end

  def create(fields)
    Game.transaction do
      player_name = fields[:player]
      fields.delete :player
      game = Game.new(fields)
      game.save! rescue raise ValidationError.new (game.errors)
      player_interactor.create(game, player_name)
      game.calculate_status!
      game
    end
  end

  private

    def player_interactor
      PlayerInteractor.instance
    end

end