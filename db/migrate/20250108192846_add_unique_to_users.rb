class AddUniqueToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :username, unique: true
    add_index :users, :email_address, unique: true
    add_index :users, :twitter_id, unique: true
  end
end