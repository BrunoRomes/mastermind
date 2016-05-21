require "singleton"
class GameInteractor
  include Singleton

  def create(fields)
    game = Game.new(fields)
    game.save! rescue raise ValidationError.new (game.errors)
    game
  end

end