class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flower_mountain, null: false, foreign_key: true
      t.text :content
      t.string :image_url
      t.integer :likes_count

      t.timestamps
    end
  end
end
