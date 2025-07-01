class MigrateNotificationToSeparateFlowerAndMountain < ActiveRecord::Migration[7.1]
  def up
    # flower_id / mountain_id を追加
    add_reference :notifications, :flower, foreign_key: true
    add_reference :notifications, :mountain, foreign_key: true

    # flower_mountain_id が null でない通知を処理
    Notification.reset_column_information
    Notification.find_each do |notification|
      if notification.flower_mountain_id.present?
        fm = FlowerMountain.find_by(id: notification.flower_mountain_id)
        if fm
          notification.update_columns(flower_id: fm.flower_id, mountain_id: fm.mountain_id)
        end
      end
    end

    # flower_mountain_id を削除（移行が終わったあと）
    remove_reference :notifications, :flower_mountain, foreign_key: true
  end

  def down
    add_reference :notifications, :flower_mountain, foreign_key: true
    Notification.reset_column_information
    Notification.find_each do |notification|
      if notification.flower_id.present? && notification.mountain_id.present?
        fm = FlowerMountain.find_by(flower_id: notification.flower_id, mountain_id: notification.mountain_id)
        notification.update_columns(flower_mountain_id: fm.id) if fm
      end
    end
    remove_reference :notifications, :flower, foreign_key: true
    remove_reference :notifications, :mountain, foreign_key: true
  end
end
