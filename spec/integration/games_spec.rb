require "spec_helper"

describe "Games api" do

  context "Get available games" do
    before do
      @game_in_idle = create(:game, status: :waiting_for_players_to_join)
      @game_in_execution = create(:game, status: :playing)
      @game_finished = create(:game, status: :finished)
    end

    it "successfully returns all available games" do
      get "/games/availables", {}, json_headers

      expect(response).to have_http_status(200)
      expect(json.size).to eq 1

      expect_exact_json_keys(json[0], "game_key", "code_length", "status", "number_of_players", "max_turns", "allow_repetition", "colors", "free_slots", "players")
      expect_json_values_present(json[0], "game_key", "code_length", "status", "max_turns", "colors", "free_slots")
      expect(json[0]["game_key"]).to eq @game_in_idle.game_key
    end

  end

  context "Get game" do

    it "successfully returns an idle game" do
      game = create(:game, status: :waiting_for_players_to_join)
      get "/games/#{game.game_key}", {}, json_headers

      expect(response).to have_http_status(200)

      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "allow_repetition", "colors", "players", "current_turn")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "colors", "current_turn")
      expect(json["game_key"]).to eq game.game_key
    end

    it "successfully returns a running game" do
      game = create(:game, status: :playing)
      get "/games/#{game.game_key}", {}, json_headers

      expect(response).to have_http_status(200)

      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "allow_repetition", "colors", "players", "current_turn")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "colors", "current_turn")
      expect(json["game_key"]).to eq game.game_key
    end

    it "successfully returns a finished game" do
      game = create(:game, status: :finished)
      get "/games/#{game.game_key}", {}, json_headers

      expect(response).to have_http_status(200)

      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "allow_repetition", "colors", "current_turn", "players", "winner")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "colors", "current_turn")
      expect(json["game_key"]).to eq game.game_key
    end

  end
  
  context "Create Game" do

    it "successfully creates a Game" do
      player_name = "John Doe"
      post "/games", attributes_for(:game).merge({player: player_name}).to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key", "players", "my_guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key", "players")
      expect(json["status"]).to eq "waiting_for_players_to_join"
      expect(json["players"].size).to eq 1
      expect(json["players"][0]).to eq player_name
    end

    it "successfully creates a singleplayer Game" do
      player_name = "John Doe"
      post "/games", attributes_for(:game, number_of_players: 1).merge({player: player_name}).to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key", "players", "my_guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key", "players")
      expect(json["status"]).to eq "playing"
      expect(json["players"].size).to eq 1
      expect(json["players"][0]).to eq player_name
    end

    it "does not create an invalid Game" do
      post "/games", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "max_turns")
    end


  end


end