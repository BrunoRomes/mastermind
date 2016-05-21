require "spec_helper"

describe "Games api" do

  context "Get games" do
    before do
      @game_in_idle = create(:game, status: :waiting_for_players_to_join)
      @game_in_execution = create(:game, status: :playing)
      @game_finished = create(:game, status: :finished)
    end

    it "successfully returns all available games" do
      get "/games", {}, json_headers

      expect(response).to have_http_status(200)
      expect(json.size).to eq 1

      expect_exact_json_keys(json[0], "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "free_slots")
      expect_json_values_present(json[0], "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "free_slots")
    end

  end
  
  context "Create Game" do

    it "successfully creates a Game" do
      post "/games", attributes_for(:game).merge({player: "John Doe"}).to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key")
    end

    it "successfully creates a singleplayer Game" do
      post "/games", attributes_for(:game, number_of_players: 1).merge({player: "John Doe"}).to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key")
      expect(json["status"]).to eq "playing"
    end

    it "does not create an invalid API" do
      post "/games", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "max_turns")
    end


  end


end