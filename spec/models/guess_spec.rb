require "spec_helper"

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

end