class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :s3_id
      t.string :visible_to
      t.text :description
      t.integer :album_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.integer :privacy
      t.timestamps
    end
    add_index :images, :id, :unique => true
  end
end
