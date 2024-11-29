class RemoveUserColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :moves, :user
  end
end
