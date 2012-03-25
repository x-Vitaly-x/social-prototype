class User < ActiveRecord::Base
  belongs_to :identity, :foreign_key => "uid", :dependent => :destroy

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end
