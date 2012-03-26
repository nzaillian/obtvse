class Post < ActiveRecord::Base
  before_validation :slugify_title
  attr_protected :blog_id

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: {scope: :blog_id}

  belongs_to :blog

  default_scope order('created_at desc')

  private
  def slugify_title
    self.slug = self.title.parameterize
  end
end
