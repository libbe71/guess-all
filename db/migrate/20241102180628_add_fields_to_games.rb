class AddFieldsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :player1_choosen_character, :string
    add_column :games, :player2_choosen_character, :string
    add_column :games, :player1_characters_left, :string
    add_column :games, :player2_characters_left, :string
    add_reference :games, :round, foreign_key: { to_table: :users }
  end
end