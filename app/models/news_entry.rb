# == Schema Information
#
# Table name: news_entries
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  approved    :boolean
#

require 'rubygems'
require 'sanitize'

class NewsEntry < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :entry_mappings
  has_many :map_entries, :through => :entry_mappings
  validates_presence_of :title
  validates_presence_of :user_id
  validates_presence_of :description

  scope :search, lambda { |param|
    if param and !param.blank?
      where("news_entries.description LIKE :query OR news_entries.title LIKE :query", :query => ("%" + param + "%"))
    end
  }
  scope :next_stack, lambda { |offset, limit| {:limit => limit, :offset => offset, :order => "id DESC"} }
  scope :made_since, lambda { |last_timestamp|
    where("news_entries.id > ?", last_timestamp)
  }

  def basic_representation
    # general web representation
    {
        :id => id,
        :user_id => user_id,
        :title => title,
        :description => Sanitize.clean(description.split("x-cut-x")[0], Sanitize::Config::BASIC),
        :rendered => false
    }
  end

  def opened_representation
    # toggled representation
    res = basic_representation
    res[:description_long] = Sanitize.clean(description.gsub("x-cut-x", ""), Sanitize::Config::RELAXED)
    res[:rendered] = true
    res
  end
end
