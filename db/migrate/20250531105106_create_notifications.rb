class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flower_mountain, null: false, foreign_key: true
      t.integer :days_before
      t.date :notification_date
      t.boolean :sent

      t.timestamps
    end
  end
end
