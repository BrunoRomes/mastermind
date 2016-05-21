FactoryGirl.define do
  
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    sequence(:player_key) { |n| "PlayerKey#{n}" }
    game
  end
  
end