class AddStuffToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer

    add_column :comments, :parent_id, :integer

  end
end
