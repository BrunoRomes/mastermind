if player.present?
  json.extract! player, :player_key
  json.set! "my_guesses" do
    json.array!(player.guesses) do |guess|
      json.extract! guess, :code, :exact, :near
    end
  end
end
