class AddGeneralParamsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name_first, :string

    add_column :users, :name_last, :string

    add_column :users, :nickname, :string

    add_column :users, :gender, :boolean

  end
end
