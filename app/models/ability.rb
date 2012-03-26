class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    can [:create, :update, :destroy], Post do |post|
      user.blogs.include? post.blog
    end
    
    can :read, Post do |post|
      if !post.published
        user.blogs.include? post.blog
      else
        true  
      end
    end
    
    can [:update, :destroy], Blog do |blog|
      user.blogs.include? blog
    end
    
  end
end
