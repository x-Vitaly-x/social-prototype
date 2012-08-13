# == Schema Information
#
# Table name: entry_mappings
#
#  news_entry_id :integer(4)
#  map_entry_id  :integer(4)
#  position      :integer(4)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class EntryMapping < ActiveRecord::Base
end
