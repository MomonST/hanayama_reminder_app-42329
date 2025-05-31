class CreateFlowers < ActiveRecord::Migration[7.1]
  def change
    create_table :flowers do |t|
      t.string :name
      t.string :scientific_name
      t.integer :bloom_start_month
      t.integer :bloom_end_month
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
