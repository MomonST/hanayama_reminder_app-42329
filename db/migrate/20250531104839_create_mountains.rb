class CreateMountains < ActiveRecord::Migration[7.1]
  def change
    create_table :mountains do |t|
      t.string :name
      t.string :region
      t.string :difficulty_level
      t.integer :elevation
      t.decimal :latitude
      t.decimal :longitude
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
