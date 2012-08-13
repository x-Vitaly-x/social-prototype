class AddFacebookParamsToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_avatar_url, :string

    add_column :users, :facebook_id, :integer

  end
end
