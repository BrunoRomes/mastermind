class GamesCleanupJob < ActiveJob::Base
  queue_as :cleanup

  def perform(game, original_time_as_float)
    if(game.updated_at.to_f <= original_time_as_float && !game.finished?)
      game.force_finish
      game.save!
    end
  end
end
