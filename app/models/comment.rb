# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  news_entry_id :integer
#  user_id       :integer
#  parent_id     :integer
#  image_id      :integer
#

require 'rubygems'
require 'sanitize'

class Comment < ActiveRecord::Base
  belongs_to :news_entry
  belongs_to :image
  belongs_to :user
  belongs_to :parent, :class_name => Comment, :foreign_key => :parent_id
  validates_presence_of :content
  validates_presence_of :user_id

  def self.real
    where("user_id IS NOT null")
  end

  def basic_representation
    p "id - #{id.to_s} / user_id - #{user_id}"
    userx = self.user
    # general web representation
    return {
        :id => id,
        :parent_id => parent_id,
        :news_entry_id => news_entry_id,
        :image_id => image_id,
        :content => Sanitize.clean(content, Sanitize::Config::BASIC),
        :user => {
            :id => userx.id,
            :name =>   userx.full_name,
            :avatar => userx.get_icon
        }
    }
  end
end
