class Game < ActiveRecord::Base

  DEFAULT_AMOUNT_OF_TURNS = 10
  MAX_AMOUNT_OF_TURNS = 25
  MAX_NUMBER_OF_PLAYERS = 10
  ALLOWED_COLORS = [ "R", "B", "G", "Y", "O", "P", "C", "M" ]

  enum status: {
    waiting_for_players_to_join: 0, playing: 1, finished: 2
  }

  validates :game_key, uniqueness: true
  validates :game_key, :code, presence: true
  validates :number_of_players, inclusion: { in: 1..MAX_NUMBER_OF_PLAYERS }
  validates :max_turns, inclusion: { in: 1..MAX_AMOUNT_OF_TURNS }

  before_validation :generate_game_key!
  before_validation :generate_code!

  before_save :update_status

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

  def update_status
    return if finished?
    if game_start?
      self.status = :playing
    else
      self.status = :waiting_for_players_to_join
    end
  end

  def game_ended?
    current_turn == max_turns
  end

  def single_player?
    number_of_players == 1
  end


  private
    def game_start?
      single_player? || all_players_joined?
    end

    def all_players_joined?
      # TODO: Implement
      false
    end

end