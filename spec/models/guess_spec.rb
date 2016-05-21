require 'rails_helper'

describe Guess do
  
  context "validations" do

    it "does not create a Guess without a game" do
      guess = build(:guess, game: nil)
      expect(guess).to_not be_valid
      expect(guess.errors).to include(:game)
    end

    it "does not create a Guess without a player" do
      guess = build(:guess, player: nil)
      expect(guess).to_not be_valid
      expect(guess.errors).to include(:player)
    end

    it "does not create a Guess without a code" do
      guess = build(:guess, code: nil)
      expect(guess).to_not be_valid
      expect(guess.errors).to include(:code)
    end

    it "does not create a Guess with a code of size different than the Game code size" do
      guess = build(:guess, code: "RB")
      expect(guess).to_not be_valid
      expect(guess.errors).to include(:code)
    end

    it "does not create a Guess with a code with colors not allowed" do
      guess = build(:guess, code: "ABCXYZHJ")
      expect(guess).to_not be_valid
      expect(guess.errors).to include(:code)
    end

    it "create a Guess with a code of size of the Game code size" do
      guess = build(:guess, code: "RBRBRBRB")
      expect(guess).to be_valid
    end

  end

  context "calculations" do
    before do
      # ALLOWED_COLORS = [ "R", "B", "G", "Y", "O", "P", "C", "M" ]
      @game_code = "RBGPCMRB"
    end

    it "does not count any exact and any near when the code is completely wrong" do
      guess = build(:guess, code: "OOOOOOOO")
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 0
      expect(guess.near).to eq 0
    end

    it "counts 8 exact and 0 near when the code is completely right" do
      guess = build(:guess, code: @game_code)
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 8
      expect(guess.near).to eq 0
    end

    it "counts 1 near when the code has a right color in the wrong position" do
      guess = build(:guess, code: "POOOOOOO")
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 0
      expect(guess.near).to eq 1
    end

    it "counts 1 near when the code has a right color in the wrong position even when the game code has repetition" do
      guess = build(:guess, code: "OROOOOOO")
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 0
      expect(guess.near).to eq 1
    end

    it "counts more than 1 near when the code has a right color multiple times in the wrong positions and the game code has repetition" do
      guess = build(:guess, code: "ORROOOOO")
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 0
      expect(guess.near).to eq 2
    end
    
    it "does not count near more than the occurrencies of the color in the game code" do
      guess = build(:guess, code: "ORRRRROO")
      guess.calculate_result! @game_code
      expect(guess.exact).to eq 0
      expect(guess.near).to eq 2
    end

  end

end