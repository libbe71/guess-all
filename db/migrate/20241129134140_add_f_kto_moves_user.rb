class AddFKtoMovesUser < ActiveRecord::Migration[7.1]
  def change
    # Add the user_id column (ensure it matches the data type of the primary key in the referenced table)
    add_column :moves, :user_id, :bigint
    add_foreign_key :moves, :users
  end
end
