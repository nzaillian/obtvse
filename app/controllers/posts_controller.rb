require 'rdiscount'

class PostsController < ApplicationController
  before_filter :find_post, :except => :index
  before_filter :find_blog
	layout 'blogs'

	def index
    @posts = Blog.find_by_slug(params[:blog_slug]).posts.where(:draft => false).page(params[:page]).per(10)

		respond_to do |format|
			format.html
			format.xml { render :xml => @posts }
			format.rss { render :layout => false }
		end
	end

	def show
		@show = true
    if @blog and params[:post_slug]
      @posts = @blog.posts.find_by_slug(params[:post_slug])
    elsif params[:id]
      @post = Post.find_by_id(params[:id])
      @blog = @post.blog
    end
    authorize! :read, @post

		respond_to do |format|
			if @post.present?
				format.html
				format.xml { render :xml => @post }
			else
				format.any { head status: :not_found  }
			end
		end
	end

	def new
		@no_header = true
		@posts = Blog.find_by_slug(params[:blog_slug]).posts.page(params[:page]).per(20)
		@post = Post.new
    @post.blog = Blog.find_by_slug(params[:blog_slug])

		respond_to do |format|
			format.html
			format.xml { render xml: @post }
		end
	end

	def edit
		@no_header = true
	end

	def create
		@post = Post.new(params[:post])

    # b/c we've marked 'blog_id' as a protected attribute
    @post.blog_id = params[:post][:blog_id]
    authorize! :create, @post

		respond_to do |format|
			if @post.save
				format.html { redirect_to :controller => 'posts', :action => 'edit',
                                  :blog_slug => @post.blog.slug, :post_slug => @post.slug,
                                  :notice => "Post created successfully" }
				format.xml { render :xml => @post, :status => :created, location: @post }
			else
				format.html { render :action => 'new' }
				format.xml { render :xml => @post.errors, :status => :unprocessable_entity}
			end
		end
	end

	def update
		@post = Post.find_by_id(params[:id])
    authorize! :update, @post

		respond_to do |format|
			if @post.update_attributes(params[:post])
				format.html { redirect_to  :controller => 'posts',
                                   :action => 'edit',
                                   :blog_slug => @post.blog.slug,
                                   :post_slug => @post.slug,
                                   :notice => "Post updated successfully" }
				format.xml { head :ok }
			else
				format.html { render :action => 'edit' }
				format.xml { render :xml => @post.errors, :status => :unprocessable_entity}
			end
		end
	end

	def destroy
		@post = Post.find_by_id(params[:id])
    authorize! :destroy, @post
		@post.destroy

		respond_to do |format|
			format.html { redirect_to :controller => 'blogs',
                                :action => 'admin',
                                :blog_slug => @post.blog.slug}
			format.xml { head :ok }
		end
	end

	private

	def choose_layout
		if ['admin', 'new', 'edit'].include? action_name
			'admin'
		else
			'application'
		end
  end

  private
  def find_post
    if params[:blog_slug] and params[:post_slug]
      @post = Blog.find_by_slug(params[:blog_slug]).posts.find_by_slug(params[:post_slug])
    elsif params[:id]
      @post = Post.find_by_id(params[:id])
    end
  end

  def find_blog
    @blog = Blog.find_by_slug(params[:blog_slug])
  end
end
