# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatMessage < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :content

  scope :next_stack, lambda { |offset, limit| {:limit => limit, :offset => offset, :order => "id DESC"} }
  scope :made_since, lambda { |last_timestamp|
    where("chat_messages.id > ?", last_timestamp)
  }

  def basic_representation
    user = self.user
    return {
        :id => id,
        :username => user.full_name,
        :content => content,
        :avatar => user.get_icon,
        :user_id => user_id
    }
  end
end
