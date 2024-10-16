class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends do |t|
      t.references :user1, foreign_key: { to_table: :users }
      t.references :user2, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
