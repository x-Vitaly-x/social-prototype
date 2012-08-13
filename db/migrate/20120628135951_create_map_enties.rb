class CreateMapEnties < ActiveRecord::Migration
  def change
    create_table :map_entries do |t|
      t.string :title
      t.text :description
      t.float :lat
      t.float :lng
      t.integer :user_id
      t.timestamps
    end
  end
end
