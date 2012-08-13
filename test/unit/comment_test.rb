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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
