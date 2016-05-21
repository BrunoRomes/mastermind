require "spec_helper"

describe "Games api" do
  
  context "Create Game" do

    it "successfully creates a Game" do
      post "/games", attributes_for(:game).to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors")
    end

    it "does not create an invalid API" do
      post "/games", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "max_turns")
    end


  end


end