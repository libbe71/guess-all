class UpdateGamesAndFriendsContraints < ActiveRecord::Migration[7.1]
  def change
    change_column_null :friends, :user1_id, true
  end
end
