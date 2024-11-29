class CreateMoves < ActiveRecord::Migration[7.1]
  def change
    create_table :moves do |t|
      t.string :question_user
      t.string :references
      t.references :game, null: false, foreign_key: true
      t.string :question
      t.string :answer
      t.integer :position

      t.timestamps
    end
  end
end
