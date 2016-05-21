class GamesCleanupJob < ActiveJob::Base
  queue_as :cleanup

  def perform(game)
    if(game.updated_at <= DateTime.now && !game.finished?)
      game.force_finish
      game.save!
    end
  end
end
