require "singleton"
class PlayerInteractor
  include Singleton

  def get(player_key)
    player = Player.find_by player_key: player_key
    raise NotFoundError.new if player.nil?
    player
  end

  def create(game, name)
    raise CannotJoinError.new unless game.waiting_for_players_to_join?
    player = Player.new(name: name, game: game)
    player.save! rescue raise ValidationError.new (player.errors)
    game.set_status!
    player
  end

end