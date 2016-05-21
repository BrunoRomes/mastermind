require "spec_helper"

describe "Players api" do

  context "Join game" do

    it "successfully joins an idle game" do
      player_attributes = attributes_for(:player)
      game = create(:game, status: :waiting_for_players_to_join)
      post "/games/#{game.game_key}/players", {player: player_attributes[:name]}.to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key", "players", "my_guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key", "players")
      expect(json["players"].size).to eq 1
      expect(json["players"][0]).to eq player_attributes[:name]
    end

    it "fails to join a game that is already playing" do
      game = create(:game, status: :playing)
      post "/games/#{game.game_key}/players", attributes_for(:player).to_json, json_headers

      expect(response).to have_http_status(403)
    end

    it "fails to join a game that does not exist" do
      game_key = "no_key"
      post "/games/#{game_key}/players", attributes_for(:player).to_json, json_headers

      expect(response).to have_http_status(404)
    end

  end
  
end