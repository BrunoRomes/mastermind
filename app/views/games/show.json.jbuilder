json.partial! 'games/game', game: @game
json.extract! @game, :current_turn

if @game.finished?
  json.extract! @game, :winner
  json.set! "guesses" do
    @game.guesses.group_by(&:player).each do |player, guesses|
      json.set! player.name do
        json.array!(guesses) do |guess|
          json.extract! guess, :code, :exact, :near
        end
      end
    end

  end
else
  json.extract! @player, :player_key
  json.set! "my_guesses" do
    json.array!(@player.guesses) do |guess|
      json.extract! guess, :code, :exact, :near
    end
  end
end
