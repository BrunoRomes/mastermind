class GameObserver < ActiveRecord::Observer

  def after_save(game)
    GamesCleanupJob.set(wait: Game::MAX_INACTIVITY_TIME).perform_later(game, DateTime.now.to_s)
  end
end