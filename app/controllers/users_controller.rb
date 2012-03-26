class UsersController < ApplicationController
  layout 'users'

  def register
    if request.post?
      @user = User.new(params[:user])
      if !@user.save
        render and return
      else
        session[:user_id] = @user.id
        redirect_to(:controller => 'blogs', :action => 'index', :notice => 'Welcome To Obtvse')
      end
    else
      @user = User.new
    end
  end

  def login
    if request.post?
      @user = User.find_by_email(params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
          session[:user_id] = @user.id
          redirect_to(:controller => 'application', :action => 'homepage_router') and return
        elsif !@user
          # for our end-users, absent record equates to invalid email, so...
          @user = User.new
          @user.errors[:email] << "is not associated with any account."
        else
          @user.errors[:password] << "is incorrect."
        end
    else
      @user = User.new
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :controller => 'application', :action => 'homepage_router'
  end
end