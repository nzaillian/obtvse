class Blog < ActiveRecord::Base
  before_validation :slugify_title
  
  attr_protected :user_id, :slug
  belongs_to :user
  has_many :posts

  validates :title, :presence => true
  validates :slug, :presence => true, :uniqueness => true
  
  serialize :settings
  
  private

  def slugify_title 
    self.slug = self.title.parameterize
  end
end