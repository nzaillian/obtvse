require 'rdiscount'

class PostsController < ApplicationController
  before_filter :find_post, :except => :index
  before_filter :find_blog
	layout 'posts'

	def index
		@posts = Blog.find_by_slug(params[:blog_slug]).posts.page(params[:page]).per(10)
		@posts = @posts.where(draft: false) if !session[:admin]

		respond_to do |format|
			format.html
			format.xml { render :xml => @posts }
			format.rss { render :layout => false }
		end
	end

	def show
		@show = true
		@post = Blog.find_by_slug(param[:blog_slug]).posts.find_by_slug_and_draft(params[:slug], false)
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
		@post = Post.find_by_slug(params[:slug])

		respond_to do |format|
			if @post.update_attributes(params[:post])
				format.html { redirect_to "/edit/#{@post.id}", :notice => "Post updated successfully" }
				format.xml { head :ok }
			else
				format.html { render :action => 'edit' }
				format.xml { render :xml => @post.errors, :status => :unprocessable_entity}
			end
		end
	end

	def destroy
		@post = Post.find_by_slug(params[:slug])
		@post.destroy

		respond_to do |format|
			format.html { redirect_to '/admin' }
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
