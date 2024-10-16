class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :player1, foreign_key: { to_table: :users }
      t.references :player2, foreign_key: { to_table: :users }
      t.string :status, default: "pending"
      t.references :winner, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
  end
end
