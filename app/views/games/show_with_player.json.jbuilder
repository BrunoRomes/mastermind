json.partial! 'games/show_base', game: @game
json.extract! @game, :current_turn
json.players @game.players.map(&:name) unless @game.finished?

json.partial! 'games/end_game', game: @game if @game.finished?
json.partial! 'games/player', player: @player unless @game.finished?
