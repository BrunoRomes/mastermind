require 'rails_helper'

describe "Guesses api" do

  context "Create a guess" do

    before do
      @game = create(:game, status: :playing)
      @player1 = create(:player, game: @game)
      @player2 = create(:player, game: @game)
    end

    it "successfully creates a guess on a running game" do
      code = @game.code.split("").shuffle.join
      create(:guess, player: @player2, game: @game, code: code)
      post "/players/#{@player1.player_key}/guesses", {code: code}.to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "player_key", "players", "my_guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "player_key", "players", "my_guesses")
      expect(json["my_guesses"][0]["code"]).to eq code
      expect(json["current_turn"]).to eq (@game.current_turn+1)
    end

    it "successfully ends a game on a correct guess" do
      code = @game.code.split("").shuffle.join
      create(:guess, player: @player2, game: @game, code: code)
      code = @game.code
      post "/players/#{@player1.player_key}/guesses", {code: code}.to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "winner", "guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "winner", "guesses")
      expect(json["status"]).to eq "finished"
      expect(json["winner"]).to eq @player1.name
      expect(json["current_turn"]).to eq 1
      expect_exact_json_keys(json["guesses"], @player1.name, @player2.name)
      expect(json["guesses"][@player1.name][0]["code"]).to eq code
    end

    it "successfully ends a game when the current turn tops the max turns" do
      @game.update_attribute(:max_turns, 1)
      code = @game.code.split("").shuffle.join
      create(:guess, player: @player2, game: @game, code: code)
      post "/players/#{@player1.player_key}/guesses", {code: code}.to_json, json_headers

      expect(response).to have_http_status(201)
      expect_exact_json_keys(json, "game_key", "code_length", "status", "number_of_players", "max_turns", "current_turn", "allow_repetition", "colors", "winner", "guesses")
      expect_json_values_present(json, "game_key", "code_length", "status", "max_turns", "current_turn", "colors", "guesses")
      expect(json["status"]).to eq "finished"
      expect(json["winner"]).to be_nil
      expect(json["current_turn"]).to eq 2
      expect_exact_json_keys(json["guesses"], @player1.name, @player2.name)
      expect(json["guesses"][@player1.name][0]["code"]).to eq code
    end

    it "does not allow the player to guess when the game has not started" do
      @game.update_attribute(:status, :waiting_for_players_to_join)
      create(:guess, player: @player1, game: @game)
      post "/players/#{@player1.player_key}/guesses", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "game")
    end

    it "does not allow the player to guess when the game has ended" do
      @game.update_attribute(:status, :finished)
      create(:guess, player: @player1, game: @game)
      post "/players/#{@player1.player_key}/guesses", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "game")
    end

    it "does not allow the same player to guess more than once in a turn" do
      create(:guess, player: @player1, game: @game)
      post "/players/#{@player1.player_key}/guesses", {}.to_json, json_headers

      expect(response).to have_http_status(422)
      expect_exact_json_values_present(json, "guess")
    end

    it "does not a player that does not exist to guess" do
      player_key = "player_that_does_not_exist"
      post "/players/#{player_key}/guesses", {}.to_json, json_headers

      expect(response).to have_http_status(404)
    end

  end
  
end