class Guess < ActiveRecord::Base

  belongs_to :game
  belongs_to :player

  validates :code, :player, :game, presence: true
  validates :code, length: { is: Game::CODE_SIZE }
  validates :code, format: { with: /\A[#{Game::ALLOWED_COLORS.join}]+\z/ }

  def calculate_result!(game_code)
    calculate_exact(game_code)
    calculate_near(game_code)
  end

  def correct?
    self.exact == Game::CODE_SIZE
  end

  private
    def calculate_exact(game_code)
      (1..Game::CODE_SIZE).each { |i| self.exact += 1 if game_code[i-1] == self.code[i-1] }
    end

    def calculate_near(game_code)
      # Using an array of colors of the guess, it is then transformed into a hash where the key is the color and the value is the number of occurencies in the code
      code_occurrencies = code.split("").reduce(Hash.new(0)) {|hash, element| hash[element] += 1; hash}
      # Calulates the matches of colors without worrying about the positions
      matches = code_occurrencies.reduce(0) do |matches, (color, occurrencies)|
        game_code_color_count = game_code.count(color)
        matches += game_code_color_count if game_code_color_count > 0 && occurrencies > game_code_color_count
        matches += occurrencies if game_code_color_count > 0 && occurrencies <= game_code_color_count
        matches
      end

      # Removes the exact amount, since they are in the correct position
      self.near = matches - self.exact
      
    end

end