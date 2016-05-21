class Guess < ActiveRecord::Base

  belongs_to :game
  belongs_to :player

  validates :code, :player, :game, presence: true
  validates :code, length: { is: Game::CODE_SIZE }
  validates :code, format: { with: /\A[#{Game::ALLOWED_COLORS.join}]+\z/ }

  def calculate_result(game_code)
    # TODO: Implement
    self.exact = Game::CODE_SIZE
  end

  def correct?
    self.exact == Game::CODE_SIZE
  end

end