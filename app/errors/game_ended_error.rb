class GameEndedError < StandardError
  attr_reader :game_key

  def initialize(game_key)
    @game_key = game_key
  end
end