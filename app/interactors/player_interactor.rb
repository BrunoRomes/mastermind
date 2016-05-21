require "singleton"
class PlayerInteractor
  include Singleton

  def create(game, name)
    player = Player.new(name: name, game: game)
    player.save! rescue raise ValidationError.new (player.errors)
    player
  end

end