class BlogsAddSlugColumn < ActiveRecord::Migration
  def up
    add_column :blogs, :slug, :string
  end

  def down
    remove_column :blogs, :slug
  end
end
