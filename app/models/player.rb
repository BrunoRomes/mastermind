class Player < ActiveRecord::Base
  has_secure_token :player_key

  belongs_to :game
  has_many :guesses

  validates :player_key, uniqueness: true
  validates :player_key, :name, :game, presence: true

  before_validation :generate_player_key!

  def generate_player_key!
    regenerate_player_key unless player_key.present?
  end

  def guessed_this_turn?(turn)
    guesses.count == turn
  end

end