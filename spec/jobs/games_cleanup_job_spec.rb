require 'rails_helper'

describe GamesCleanupJob do
  context "Game cleanup" do

    before do
      
    end

    it "does nothing when the last update was less then time limit for inactivity" do
      game = create(:game, updated_at: DateTime.now)
      GamesCleanupJob.perform_now(game)
      loaded_game = Game.find(game.id)
      expect(loaded_game.status).to eq game.status
    end

    it "ends a game when the last update was more then time limit for inactivity" do
      game = create(:game, updated_at: DateTime.now - Game::MAX_INACTIVITY_TIME)
      GamesCleanupJob.perform_now(game)
      loaded_game = Game.find(game.id)
      expect(loaded_game.status).to eq "finished"
    end

  end
end
