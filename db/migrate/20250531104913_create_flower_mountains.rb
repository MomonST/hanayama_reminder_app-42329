class CreateFlowerMountains < ActiveRecord::Migration[7.1]
  def change
    create_table :flower_mountains do |t|
      t.references :flower, null: false, foreign_key: true
      t.references :mountain, null: false, foreign_key: true
      t.integer :peak_month
      t.text :bloom_info

      t.timestamps
    end
  end
end
