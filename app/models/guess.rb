class Guess < ActiveRecord::Base

  belongs_to :game
  belongs_to :player

  validates :code, :player, :game, presence: true
  validates :code, length: { is: Game::CODE_SIZE }
  validates :code, format: { with: /\A[#{Game::ALLOWED_COLORS.join}]+\z/ }

  def calculate_result!(game_code)
    calculate_exact(game_code)
    calculate_near(game_code)
    # TODO: Implement
  end

  def correct?
    self.exact == Game::CODE_SIZE
  end

  private
    def calculate_exact(game_code)
      (1..Game::CODE_SIZE).each { |i| self.exact += 1 if game_code[i-1] == self.code[i-1] }
    end

    def calculate_near(game_code)
      code_occurrencies = code.split("").reduce(Hash.new(0)) {|hash, element| hash[element] += 1; hash}
      self.near = code_occurrencies.reduce(0) do |near, (color, occurrencies)|
        game_code_color_count = game_code.count(color)
        near += game_code_color_count if game_code_color_count > 0 && occurrencies > game_code_color_count
        near += occurrencies if game_code_color_count > 0 && occurrencies <= game_code_color_count
        near
      end

      self.near -= self.exact
      self.near = 0 if self.near < 0
    end

end