# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  s3_id              :string(255)
#  visible_to         :string(255)
#  description        :text
#  album_id           :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  privacy            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  type               :string(255)
#  position           :integer
#

class Image < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  set_primary_key :id
  belongs_to :album
  has_many :comments
  has_attached_file :image,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "albums/:album_id/:filename"
  validates_attachment_presence :image
  validates_presence_of :album_id, :s3_id
  after_create :set_position
  default_scope :order => "position DESC"
  scope :by_user, lambda { |user_id, offset, limit|
    find(:all, :joins => :album, :conditions => {"albums.user_id" => user_id}, :limit => limit, :offset => offset, :order => "position DESC")
  }

  def basic_representation
    user_id = album.user_id
    {
        :id => id,
        :s3_id => s3_id,
        :description => description,
        :album_id => album_id,
        :icon => url_thumb,
        :image => url_original,
        :position => position,
        :user_id => user_id
    }
  end

  def set_position
    # original order - order of creation
    self.update_attribute(:position, self.id)
  end

  def url_original
    # for some reason, paperclip really screws up aws s3 url generation. This is why I overwrite this method
    "http://#{YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env].symbolize_keys[:bucket]}.s3.amazonaws.com/albums/#{self.album_id.to_s}/#{self.image_file_name.to_s}"
  end

  def url_thumb
    # for some reason, paperclip really screws up aws s3 url generation. This is why I overwrite this method
    "http://#{YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env].symbolize_keys[:bucket]}.s3.amazonaws.com/albums/#{self.album_id.to_s}/thumbs/#{self.image_file_name.to_s}"
  end

end
