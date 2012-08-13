class AddPositionToAlbumsAndImages < ActiveRecord::Migration
  def change
    add_column :albums, :position, :integer
    add_column :images, :position, :integer
  end
end
