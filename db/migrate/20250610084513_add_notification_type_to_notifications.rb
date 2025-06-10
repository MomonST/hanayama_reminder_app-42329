class AddNotificationTypeToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :notification_type, :string, null: false, default: 'reminder'
  end
end
