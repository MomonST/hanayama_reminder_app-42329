Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/show'
  get 'posts/new'
  get 'posts/create'
  get 'posts/edit'
  get 'posts/update'
  get 'posts/destroy'
  get 'favorites/index'
  get 'favorites/create'
  get 'favorites/destroy'
  get 'notifications/index'
  get 'notifications/new'
  get 'notifications/create'
  get 'notifications/edit'
  get 'notifications/update'
  get 'notifications/destroy'
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  get 'home/index'
  devise_for :users
  
end
