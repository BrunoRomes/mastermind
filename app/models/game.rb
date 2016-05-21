class Game < ActiveRecord::Base
  has_secure_token :game_key

  DEFAULT_AMOUNT_OF_TURNS = 10
  MAX_AMOUNT_OF_TURNS = 25
  MAX_NUMBER_OF_PLAYERS = 10
  ALLOWED_COLORS = [ "R", "B", "G", "Y", "O", "P", "C", "M" ]
  CODE_SIZE = 8
  MAX_INACTIVITY_TIME = 5.minutes
  
  has_many :players
  has_many :guesses

  enum status: {
    waiting_for_players_to_join: 0, playing: 1, finished: 2
  }

  validates :game_key, uniqueness: true
  validates :game_key, :code, presence: true
  validates :number_of_players, inclusion: { in: 1..MAX_NUMBER_OF_PLAYERS }
  validates :max_turns, inclusion: { in: 1..MAX_AMOUNT_OF_TURNS }

  before_validation :generate_game_key!
  before_validation :generate_code!
  before_validation :set_default_turns

  def generate_game_key!
    regenerate_game_key unless game_key.present?
  end

  def generate_code!
    return if code.present?
    self.code = allow_repetition? ? generate_code_allowing_repetition : generate_code_without_repetition
  end

  def set_default_turns
    return if max_turns.present?
    self.max_turns = DEFAULT_AMOUNT_OF_TURNS
  end

  def set_status!
    self.status = calculate_status
    save!
  end

  def finish(winner)
    self.winner = winner
    force_finish
  end

  def force_finish
    self.status = :finished
  end

  def self.find_availables
    self.where(status: Game.statuses[:waiting_for_players_to_join])
  end

  def increase_turn
    self.current_turn = (guesses.count / number_of_players).floor + 1
  end

  def game_ended?
    finished? || current_turn > max_turns
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

    def generate_code_allowing_repetition
    rng = Random.new
    (1..CODE_SIZE).reduce([]) do |array, int|
      array << ALLOWED_COLORS[rng.rand(ALLOWED_COLORS.size)]
      array
    end.join
  end

  def generate_code_without_repetition
    ALLOWED_COLORS.shuffle.join
  end

end