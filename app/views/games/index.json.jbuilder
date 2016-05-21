json.array!(@games) do |game|
  json.extract! game, :game_key, :status, :number_of_players, :max_turns, :current_turn, :allow_repetition
  json.code_length game.code.size
  json.colors Game::ALLOWED_COLORS
  json.free_slots game.number_of_players - game.players.count
end
