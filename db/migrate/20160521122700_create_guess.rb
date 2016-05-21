class CreateGuess < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.references :game, index: true
      t.references :player, index: true
      t.integer :exact, default: 0
      t.integer :near, default: 0
      t.string :code
    end
  end
end
