class CreateEntryMappings < ActiveRecord::Migration
  def change
    create_table :entry_mappings do |t|
      t.integer :news_entry_id
      t.integer :map_entry_id
      t.integer :position

      t.timestamps
    end
  end
end
