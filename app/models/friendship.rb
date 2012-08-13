class Friendship < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :followee, :class_name => 'User', :foreign_key => 'followee_id'
  validates_uniqueness_of :follower_id, :scope => [:followee_id]
  validate :same_user_validation
  def same_user_validation
    if self.follower_id == self.followee_id
      raise("Stupid error. Obviously you cannot follow yourself.")
    end
  end
end
