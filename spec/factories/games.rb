FactoryGirl.define do
  
  factory :game do
    sequence(:game_key) { |n| "GameKey#{n}" }
    code "BGRRRBGR"
    number_of_players 2
    max_turns 10
  end

end