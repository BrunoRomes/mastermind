json.extract! game, :game_key, :status, :number_of_players, :max_turns, :allow_repetition
json.code_length game.code.size
json.colors Game::ALLOWED_COLORS
