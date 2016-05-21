class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_key, index: true
      t.string :code
      t.integer :number_of_players, default: 1
      t.integer :status, default: 0
      t.integer :max_turns
      t.integer :current_turn, default: 0
      t.boolean :allow_repetition, default: false

      t.timestamp
    end
  end
end
