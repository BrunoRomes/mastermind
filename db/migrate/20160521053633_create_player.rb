class CreatePlayer < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :player_key, index: true
      t.string :name
      t.references :game, index: true

      t.timestamp
    end
  end
end
