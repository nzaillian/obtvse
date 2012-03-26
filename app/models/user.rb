class User < ActiveRecord::Base
  after_initialize :set_default_properties
  
  attr_accessible :email, :password, :password_confirmation

  attr_protected :settings
  has_secure_password
  validates :password, :presence => true, :confirmation => true, :on => :create

  validates :email, \
            :uniqueness => {:message => 'has already been associated with an account'}, \
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  
  has_many :blogs
  
  # We'll store user settings as a serialized hash in a
  # text column (the 'settings' text column in the 'users' table).
  # For now, stored settings will include...
  #   - nickname, email, twitter handle and github handle 
  serialize :settings
  
  private
  def set_default_properties
    self.settings ||= {}
    self.settings[:nickname] ||= 'Your nickname'
    self.settings[:email] ||= 'your@email.com'
    self.settings[:twitter] ||= 'your_twitter_handle'
    self.settings[:github] ||= 'http://github.com/your_github_profile'
  end
end
