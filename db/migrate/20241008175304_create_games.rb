class CreateGames < ActiveRecord::Migration[6.1]
  def change
    update_table :games do |t|
      t.references :player1, foreign_key: { to_table: :users }
      t.references :player2, foreign_key: { to_table: :users }
      t.string :status, default: "started"
      t.references :winner, foreign_key: { to_table: :users }, null: true
      t.string :player1_choosen_character
      t.string :player2_choosen_character
      t.string :player1_characters_left
      t.string :player2_characters_left
      t.references :round, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
