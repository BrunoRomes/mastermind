json.partial! 'games/show_base', game: @game
json.extract! @game, :current_turn
json.players @game.players.map(&:name)

json.partial! 'games/end_game', game: @game if @game.finished?
