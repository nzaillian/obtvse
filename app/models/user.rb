class User < ActiveRecord::Base
  
  attr_accessible :email, :password, :password_confirmation

  attr_protected :settings
  has_secure_password
  validates :password, :presence => true, :confirmation => true, :on => :create

  validates :email, \
            :uniqueness => {:message => 'has already been associated with an account'}, \
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  
  has_many :blogs
end
