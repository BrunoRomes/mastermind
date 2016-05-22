class GameObserver < ActiveRecord::Observer

  def after_save(game)
    GamesCleanupJob.set(wait: Game::MAX_INACTIVITY_TIME).perform_later(game, Time.now.to_f)
  end
end