Obtvse::Application.routes.draw do
  # posts will be accessible via ID at the default '/posts' path
  # but also by slug in the namespace of their containing blog.
  resources :posts

  # blogs also will be accessible via id and slug (though the
  # latter only for certain methods)
  resources :blogs

  root to: 'application#homepage_router'

  match '/welcome' => 'application#welcome'
  match '/home' => 'blogs#index'

  match '/register' => 'users#register'
  match '/login' => 'users#login'
  match '/logout' => 'users#logout'

  scope '/:blog_slug' do
    get '/new' => 'posts#new'
    match '/admin' => 'blogs#admin'
    get '/:post_slug' => 'posts#show'
    get '/:post_slug/edit' => 'posts#edit'
  end

  match '/:blog_slug' => 'posts#index'
end