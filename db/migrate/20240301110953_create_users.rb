class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email_address
      t.string :twitter_id
      t.string :password_digest
      t.timestamps
    end
  end
end
