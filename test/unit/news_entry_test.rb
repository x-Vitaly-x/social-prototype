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

require 'test_helper'

class NewsEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
