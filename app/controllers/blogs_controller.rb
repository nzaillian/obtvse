class BlogsController < ApplicationController
  def index
    # implicit render...
  end

  def new
    redirect_to(:controller => 'users', :action => 'login') and return if !current_user
    @blog = Blog.new
  end

  def create
    redirect_to(root_url) and return if !current_user
    @blog = Blog.new(params[:blog])
    @blog.user = current_user
    if !@blog.save
      render('new') and return
    else
      redirect_to :action => 'admin', :blog_slug => @blog.slug
    end
  end

  def admin
  		@no_header = true
  		@post = Post.new
      @post.blog = Blog.find_by_id(params[:blog_slug])
  		@published = Blog.find_by_slug(params[:blog_slug]).posts.where(draft:false).page(params[:page]).per(20)
  		@drafts = Blog.find_by_slug(params[:blog_slug]).posts.where(draft:true).page(params[:page_draft]).per(20)

  		respond_to do |format|
  			format.html { render 'admin', :layout => 'admin' }
  		end
  end
end