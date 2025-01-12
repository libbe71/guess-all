class UpdateForeignKeysOnDeleteCascade < ActiveRecord::Migration[7.0]
  def change
    # Modify foreign keys for 'friends' table
    remove_foreign_key :friends, :users, column: :user1_id
    add_foreign_key :friends, :users, column: :user1_id, on_delete: :cascade

    remove_foreign_key :friends, :users, column: :user2_id
    add_foreign_key :friends, :users, column: :user2_id, on_delete: :cascade

    # Modify foreign keys for 'games' table
    remove_foreign_key :games, :users, column: :player1_id
    add_foreign_key :games, :users, column: :player1_id, on_delete: :cascade

    remove_foreign_key :games, :users, column: :player2_id
    add_foreign_key :games, :users, column: :player2_id, on_delete: :cascade

    remove_foreign_key :games, :users, column: :round_id
    add_foreign_key :games, :users, column: :round_id, on_delete: :cascade

    remove_foreign_key :games, :users, column: :winner_id
    add_foreign_key :games, :users, column: :winner_id, on_delete: :cascade

    # Modify foreign keys for 'moves' table
    remove_foreign_key :moves, :games
    add_foreign_key :moves, :games, on_delete: :cascade

    remove_foreign_key :moves, :users
    add_foreign_key :moves, :users, on_delete: :cascade
  end
end
