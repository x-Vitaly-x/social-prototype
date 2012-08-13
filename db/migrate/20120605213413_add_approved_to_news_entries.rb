class AddApprovedToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :approved, :boolean
    add_column :users, :admin, :boolean
  end
end
