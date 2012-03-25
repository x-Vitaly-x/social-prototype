class Identity < OmniAuth::Identity::Models::ActiveRecord
  has_one :user, :foreign_key => "uid"

  auth_key "name"

  attr_writer :password
  attr_accessor :password_confirmation
  attr_accessible :name, :password, :password_confirmation
  
  validates_presence_of :name, :password_confirmation
  validates_length_of :password, :in => 6..15
  
  before_validation :digest
  
  def digest
    self.password_digest = BCrypt::Password.create(password)
  end
end
