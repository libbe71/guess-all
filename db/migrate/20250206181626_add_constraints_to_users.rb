class AddConstraintsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :username, false
    change_column_null :users, :email_address, false
    change_column_null :users, :password_digest, false
    change_column_null :users, :role, false
  end
end
