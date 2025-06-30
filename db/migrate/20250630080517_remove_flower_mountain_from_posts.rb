class RemoveFlowerMountainFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_reference :posts, :flower_mountain, null: false, foreign_key: true
  end
end
