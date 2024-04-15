class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :surname
      t.string :gender
      t.date :birthdate
      t.string :phone_number
      t.string :email_address
      t.string :password_digest
      t.timestamps
    end
  end
end
