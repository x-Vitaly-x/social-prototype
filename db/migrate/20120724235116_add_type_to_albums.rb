class AddTypeToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_type, :string

  end
end
