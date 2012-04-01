class Blog < ActiveRecord::Base
  before_validation :slugify_title
  after_initialize :initialize_settings
  
  attr_protected :user_id, :slug
  belongs_to :user
  has_many :posts, :dependent => :destroy

  validates :title, :presence => true, :uniqueness => true
  validates :slug, :presence => true, :uniqueness => true

  # We'll store blog user settings as a serialized hash in a
  # text column (the 'settings' text column in the 'blogs' table).
  # For now, stored settings will include...
  #   - nickname, email, twitter handle and github handle
  serialize :settings

  serialized_attr_accessor :settings, :nickname, :email, :twitter, :github
  
  private

  def slugify_title 
    self.slug = self.title.parameterize
  end

  def initialize_settings
    self.settings ||= {}
    self.settings[:nickname] ||= 'Your nickname'
    self.settings[:email] ||= 'your@email.com'
    self.settings[:twitter] ||= 'your_twitter_handle'
    self.settings[:github] ||= 'http://github.com/your_github_profile'
  end
end