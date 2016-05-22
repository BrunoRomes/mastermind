require 'rails_helper'

describe GamesCleanupJob do
  context "Game cleanup" do

    it "does nothing when the job reference time is lower than the last update time" do
      game = create(:game, updated_at: Time.now)
      GamesCleanupJob.perform_now(game, (Time.now - 1.minute).to_f)
      loaded_game = Game.find(game.id)
      expect(loaded_game.status).to eq game.status
    end

    it "ends a game for inactivity when the job reference time is equals to the last update time" do
      game = create(:game, updated_at: Time.now)
      GamesCleanupJob.perform_now(game, Time.now.to_f)
      loaded_game = Game.find(game.id)
      expect(loaded_game.status).to eq "finished"
    end

    it "ends a game for inactivity when the job reference time is higher to the last update time" do
      game = create(:game, updated_at: Time.now)
      GamesCleanupJob.perform_now(game, (Time.now + Game::MAX_INACTIVITY_TIME).to_f)
      loaded_game = Game.find(game.id)
      expect(loaded_game.status).to eq "finished"
    end

  end
end
