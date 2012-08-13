class AddVkontakteParamsToUser < ActiveRecord::Migration
  def change
    add_column :users, :vkontakte_avatar_url, :string
    add_column :users, :vkontakte_id, :integer
  end
end
