class DropNoticedNotifications < ActiveRecord::Migration[7.0]
  def change
    drop_table :noticed_notifications
  end
end
