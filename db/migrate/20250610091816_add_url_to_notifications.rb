class AddUrlToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :url, :string, null: true # URLは必ずしも存在しないためnull: trueが一般的
  end
end
