class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def homepage_router
    if !current_user
      redirect_to :controller => 'users', :action => 'login'
    else
      redirect_to :controller => 'blogs', :action => 'index'
    end
  end

  # cancan auth plugin requires that this method be implemented.
  # So that we don't make extraneous queries, we'll 
  # set a @current_user instance variable via a before filter
  # and just alias it with this method
  def current_user
    @_current_user = User.find_by_id(session[:user_id])
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    render_401
  end

  private

  def render_401
     err_str = 'You have attempted to modify a resource for which you have insufficient privileges.'
     respond_to do |format|
      format.html { render(:text => err_str, :status => '401') and return }
      format.json { render :json => { :status => 401, :message => err_str }.to_json }
    end
  end
end
