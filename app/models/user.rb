class User < ActiveRecord::Base
  has_many :registrations, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :liked_events, :through => :likes, :source => :event

  has_secure_password
  
  validates :name, :presence    => true
  validates :email, :presence   => true, 
                    :format     => /\A(\S+)@(.+)\.(\S+)\z/i,
                    :uniqueness => {:case_sensitive => false}

  def self.authenticate(email, password)
    user = User.find_by(:email => email)
    user && user.authenticate(password)
  end

end
