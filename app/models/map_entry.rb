# == Schema Information
#
# Table name: map_entries
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  lat         :float
#  lng         :float
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rubygems'
require 'sanitize'

class MapEntry < ActiveRecord::Base
  belongs_to :user
  has_many :entry_mappings
  has_many :news_entries, :through => :entry_mappings
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :lat
  validates_presence_of :lng
  validates_presence_of :user_id

  acts_as_mappable

  scope :excluding_ids, lambda { |ids|
    where(['id NOT IN (?)', ids]) if ids.any?
  }

  def basic_representation
    # general web representation
    {
        :id => id,
        :title => title,
        :description => Sanitize.clean(description, Sanitize::Config::BASIC),
        :description_short => Sanitize.clean(description.split("x-cut-x")[0], Sanitize::Config::BASIC),
        :lat => lat,
        :lng => lng,
        :author => (user.username rescue nil)
    }
  end
end
