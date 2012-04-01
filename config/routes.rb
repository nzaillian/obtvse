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
    get '/admin' => 'blogs#admin'
    get '/edit' => 'blogs#edit'
    put '/edit' => 'blogs#update'
    get '/:post_slug' => 'posts#show'
    get '/:post_slug/edit' => 'posts#edit'
  end
  get '/:blog_slug' => 'posts#index'
  delete '/:blog_slug' => 'blogs#destroy'
end