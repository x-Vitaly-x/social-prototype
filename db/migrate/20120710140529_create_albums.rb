class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :privacy

      t.timestamps
    end
  end
end
