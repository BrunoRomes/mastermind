class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_key, index: true
      t.string :code
      t.integer :number_of_players, default: 1
      t.integer :status, default: 0, index: true
      t.integer :max_turns
      t.integer :current_turn, default: 1
      t.boolean :allow_repetition, default: false
      t.string :winner

      t.timestamp
    end
  end
end
