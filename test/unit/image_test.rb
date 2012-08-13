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

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
