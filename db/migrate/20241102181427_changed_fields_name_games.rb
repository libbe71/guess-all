class ChangedFieldsNameGames < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :player1_characters_left, :string
    remove_column :games, :player2_characters_left, :string
    add_column :games, :player1_characters_discarded, :string
    add_column :games, :player2_characters_discarded, :string
  end
end