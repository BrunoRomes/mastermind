require 'rails_helper'

describe Game do
  
  context "validations" do

    it "does not create two Games without the same game_key" do
      create(:game, game_key: "1234")
      game = build(:game, game_key: "1234")
      expect(game).to_not be_valid
      expect(game.errors).to include(:game_key)
    end

    it "does not create a Game with number of players lower than 1" do
      game = build(:game, number_of_players: 0)
      expect(game).to_not be_valid
      expect(game.errors).to include(:number_of_players)
    end

    it "does not create a Game with number of players higher than the max number allowed" do
      game = build(:game, number_of_players: Game::MAX_NUMBER_OF_PLAYERS + 1)
      expect(game).to_not be_valid
      expect(game.errors).to include(:number_of_players)
    end

    it "does not create a Game with max number of turns lower than 1" do
      game = build(:game, max_turns: 0)
      expect(game).to_not be_valid
      expect(game.errors).to include(:max_turns)
    end

    it "creates a game without max number of turns" do
      game = build(:game, max_turns: nil)
      expect(game).to be_valid
    end

  end

  context "hooks" do
    it "creates a game_key before validation when it does not exist" do
      game = build(:game, game_key: "")
      expect(game).to be_valid
      expect(game.game_key.present?).to be_truthy
    end

    it "does not create a game_key before validation when it exists" do
      game = build(:game, game_key: "ABC")
      expect(game).to be_valid
      expect(game.game_key).to eq "ABC"
    end

    it "creates a code before validation when it does not exist" do
      game = build(:game, code: "")
      expect(game).to be_valid
      expect(game.code.present?).to be_truthy
    end

    it "does not create a code before validation when it exists" do
      game = build(:game, code: "ABC")
      expect(game).to be_valid
      expect(game.code).to eq "ABC"
    end

    it "creates a code without repetition" do
      game = build(:game, code: "", allow_repetition: false)
      expect(game).to be_valid
      expect(game.code.split("").uniq.size).to eq Game::ALLOWED_COLORS.size
    end

    it "creates a valid code with repetition" do
      game = build(:game, code: "", allow_repetition: true)
      expect(game).to be_valid
    end

    it "always updates the 'updated_at' field" do
      game = create(:game)
      first_update = game.updated_at
      expect(game).to be_valid
      game.save! # Saved without changing anything originally wouldn`t update the 'updated_at' field
      expect(game.updated_at > first_update).to be_truthy
    end

  end

  context "status" do
    it "updates the status to playing when it is a singleplayer game" do
      game = create(:game, number_of_players: 1)
      create(:player, game: game)
      game.set_status!
      expect(game.status).to eq :playing.to_s
    end

    it "updates the status to playing when it is a multiplayer game and all players joined" do
      players_number = 2
      game = create(:game, number_of_players: players_number)
      players_number.times { create(:player, game: game) }
      game.set_status!
      expect(game.status).to eq :playing.to_s
    end

    it "updates the status to waiting_for_players_to_join when it is a multiplayer game and all players joined" do
      game = create(:game, number_of_players: 2)
      create(:player, game: game)
      game.set_status!
      expect(game.status).to eq :waiting_for_players_to_join.to_s
    end

  end

end