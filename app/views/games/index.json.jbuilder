json.array!(@games) do |game|
  json.partial! 'games/show_base', game: game
  json.players game.players.map(&:name)
  json.free_slots game.number_of_players - game.players.count
end
