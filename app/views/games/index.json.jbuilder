json.array!(@games) do |game|
  json.partial! 'games/game', game: game
  json.free_slots game.number_of_players - game.players.count
end
