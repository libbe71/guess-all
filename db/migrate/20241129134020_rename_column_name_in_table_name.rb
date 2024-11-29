class RenameColumnNameInTableName < ActiveRecord::Migration[7.1]
  def change
    rename_column :moves, :question_user, :user
  end
end
