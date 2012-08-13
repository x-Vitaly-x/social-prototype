# == Schema Information
#
# Table name: albums
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  user_id     :integer
#  privacy     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  thumbnail   :integer
#  position    :integer
#  album_type  :string(255)
#

class Album < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :user_id

  has_many :images
  belongs_to :user
  after_create :set_position
  default_scope :order => "position DESC"

  attr_accessible :title, :album_type, :description, :user_id, :icon, :position

  def basic_representation
    imgs = images.map(&:basic_representation)
    return {
        :id => id,
        :user_id => user_id,
        :title => title,
        :description => description,
        :images => imgs,
        :icon => (!thumbnail.nil? ? Image.find(thumbnail) : (imgs.empty? ? "/assets/blank_album.JPG" : imgs.first[:icon])),
        :position => position
    }
  end

  def set_position
    # original order - order of creation
    self.update_attribute(:position, self.id)
  end
end
