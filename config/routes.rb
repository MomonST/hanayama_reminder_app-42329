Rails.application.routes.draw do
  # Deviseのユーザー認証関連のルーティング
  devise_for :users

  # Homeページのルーティング
  root to: 'home#index'

  # Usersの編集・表示関連
  resources :users, only: [:show, :edit, :update]

  # Postsのリソースに対するRESTfulルーティング
  resources :posts, except: [:index] do
    # postsリソース内の「お気に入り」アクションを追加する場合
    resources :favorites, only: [:create, :destroy]
  end

  # 通知関連
  resources :notifications, except: [:show]

  # お気に入り関連
  resources :favorites, only: [:index]

end
