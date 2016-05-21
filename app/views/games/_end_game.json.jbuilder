json.extract! game, :winner
json.set! "guesses" do
  game.guesses.group_by(&:player).each do |player, guesses|
    json.set! player.name do
      json.array!(guesses) do |guess|
        json.extract! guess, :code, :exact, :near
      end
    end
  end

end
