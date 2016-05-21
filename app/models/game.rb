class Game < ActiveRecord::Base

  DEFAULT_AMOUNT_OF_TURNS = 10
  MAX_AMOUNT_OF_TURNS = 25
  MAX_NUMBER_OF_PLAYERS = 10
  ALLOWED_COLORS = [ "R", "B", "G", "Y", "O", "P", "C", "M" ]
  has_many :players

  enum status: {
    waiting_for_players_to_join: 0, playing: 1, finished: 2
  }

  validates :game_key, uniqueness: true
  validates :game_key, :code, presence: true
  validates :number_of_players, inclusion: { in: 1..MAX_NUMBER_OF_PLAYERS }
  validates :max_turns, inclusion: { in: 1..MAX_AMOUNT_OF_TURNS }

  before_validation :generate_game_key!
  before_validation :generate_code!

  def generate_game_key!
    return if game_key.present?
    # TODO: Generate
    self.game_key = "ABC"
  end

  def generate_code!
    return if code.present?
    # TODO: Generate
    self.code = "RBG"
  end

  def set_status!
    self.status = calculate_status
    save!
  end

  def game_ended?
    finished? || current_turn == max_turns
  end

  def self.find_availables
    self.where(status: Game.statuses[:waiting_for_players_to_join])
  end

  private
    def game_start?
      players.size == number_of_players
    end

    def calculate_status
      return :finished if game_ended?
      return :playing if game_start?
      :waiting_for_players_to_join
    end

end