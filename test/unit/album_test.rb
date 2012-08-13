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

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
