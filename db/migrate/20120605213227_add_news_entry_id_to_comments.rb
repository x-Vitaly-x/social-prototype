class AddNewsEntryIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :news_entry_id, :integer

  end
end
