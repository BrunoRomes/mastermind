class Player < ActiveRecord::Base

  belongs_to :game

  validates :player_key, uniqueness: true
  validates :player_key, :name, :game, presence: true

  before_validation :generate_player_key!

  def generate_player_key!
    return if player_key.present?
    # TODO: Generate
    self.player_key = "RBG"
  end

end