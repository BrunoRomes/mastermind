require "spec_helper"

describe Player do
  
  context "validations" do

    it "does not create two Players with the same player_key" do
      create(:player, player_key: "1234")
      player = build(:player, player_key: "1234")
      expect(player).to_not be_valid
      expect(player.errors).to include(:player_key)
    end

    it "does not create a Game without name" do
      player = build(:player, name: "")
      expect(player).to_not be_valid
      expect(player.errors).to include(:name)
    end

  end

end