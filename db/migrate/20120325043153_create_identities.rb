class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :password_digest
      t.string :name

      t.timestamps
    end
  end
end
