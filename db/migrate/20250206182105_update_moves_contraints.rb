class UpdateMovesContraints < ActiveRecord::Migration[7.1]
  def change
    change_column_null :moves, :question, false
    change_column_null :moves, :answer, false
    change_column_null :moves, :position, false
    change_column_null :moves, :user_id, false
  end
end
