class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.string :friendship_type

      t.timestamps
    end
  end
end
