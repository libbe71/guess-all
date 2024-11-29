class RemoveReferencesColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :moves, :references
  end
end
