require "spec_helper"

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

    it "does not create a Game with number of players hight than the max number allowed" do
      game = build(:game, number_of_players: Game::MAX_NUMBER_OF_PLAYERS + 1)
      expect(game).to_not be_valid
      expect(game.errors).to include(:number_of_players)
    end

    it "does not create a Game with max number of turns lower than 1" do
      game = build(:game, max_turns: 0)
      expect(game).to_not be_valid
      expect(game.errors).to include(:max_turns)
    end

    it "does not create a Game with max number of turns hight than the max number allowed" do
      game = build(:game, max_turns: Game::MAX_AMOUNT_OF_TURNS + 1)
      expect(game).to_not be_valid
      expect(game.errors).to include(:max_turns)
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

  end

  context "status" do
    it "updates the status to playing when it is a singleplayer game" do
      game = create(:game, number_of_players: 1)
      create(:player, game: game)
      game.calculate_status!
      expect(game.status).to eq :playing.to_s
    end

    it "updates the status to playing when it is a multiplayer game and all players joined" do
      game = create(:game, number_of_players: 2)
      create(:player, game: game)
      create(:player, game: game)
      game.calculate_status!
      expect(game.status).to eq :playing.to_s
    end

    it "updates the status to waiting_for_players_to_join when it is a multiplayer game and all players joined" do
      game = create(:game, number_of_players: 2)
      create(:player, game: game)
      game.calculate_status!
      expect(game.status).to eq :waiting_for_players_to_join.to_s
    end

  end

end