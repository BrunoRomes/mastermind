class GamesCleanupJob < ActiveJob::Base
  queue_as :cleanup

  def perform(game, datetime_as_string)
    datetime = datetime_as_string.to_datetime
    if(game.updated_at < datetime)
      game.force_finish
      game.save!
    end
  end
end
