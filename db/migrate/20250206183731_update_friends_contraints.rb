class UpdateFriendsContraints < ActiveRecord::Migration[7.1]
  def change
    change_column_null :friends, :status, false
    change_column_null :games, :player1_id, false
    change_column_null :games, :status, false
    change_column_null :games, :round_id, false
  end
end
