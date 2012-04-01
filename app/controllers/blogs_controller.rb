class BlogsController < ApplicationController

  def index
    render 'blogs/index', :layout => 'application'
  end

  def new
    redirect_to(:controller => 'users', :action => 'login') and return if !current_user
    @blog = Blog.new
    @blog.user = current_user
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
      @blog = Blog.find_by_slug(params[:blog_slug])
  		@post = Post.new
      @post.blog = @blog
  		@published = @blog.posts.where(draft:false).page(params[:page]).per(20)
  		@drafts = @blog.posts.where(draft:true).page(params[:page_draft]).per(20)

  		respond_to do |format|
  			format.html { render 'blogs/admin' }
  		end
  end

  def update
    @blog = Blog.find_by_slug(params[:blog_slug])
    slug_orig = @blog.slug
    authorize! :update, @blog
    if @blog.update_attributes(params[:blog])
      flash.now[:notice] = 'Your settings have been saved'
    else
      flash.  now[:notice] = 'Errors occurred saving your settings (see below)'
      # because the edit form's submit path is dependent on the slug(which is derived)
      # from the model's name, it will be incorrect if the name fails to validate
      # and we need to explicitly set it to its former value like so...
      @blog.slug = slug_orig if @blog.errors[:title].count  > 0
    end
    render :action => 'edit'
  end

  def edit
    @blog = Blog.find_by_slug(params[:blog_slug])
    authorize! :update, @blog
    render 'edit', :layout => 'blogs'
  end

  def destroy
    @blog = Blog.find_by_slug(params[:blog_slug])
    authorize! :destroy, @blog
    @blog.destroy
    redirect_to :controller => 'blogs', :action => 'index',
                :notice => "Your blog \"#{@blog.title}\" has been permanently deleted."
  end
end