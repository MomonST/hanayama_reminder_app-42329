Rails.application.routes.draw do
  # Deviseのユーザー認証関連のルーティング
  devise_for :users

  # Homeページのルーティング
  root to: 'home#index'

  # 静的ページ
  get 'about', to: 'home#about'

  # Usersの編集・表示関連
  resources :users, only: [:show, :edit, :update]

  # FlowerMountainsのリソースをRESTfulに設定
  resources :flower_mountains, only: [:index, :show]

  # 通知関連
  resources :notifications, except: [:show]

  # postsリソース内の「お気に入り」アクションを追加する場合
  resources :favorites, only: [:index, :create, :destroy]

  # Postsのリソースに対するRESTfulルーティング
  resources :posts do
    # postsリソース内の「いいね」アクションを追加
    resources :likes, only: [:create]
  end

  resources :likes, only: [:destroy]

  # API
  namespace :api do
    namespace :v1 do
      resources :flower_mountains, only: [:index]
      resources :flowers, only: [:index]
      resources :mountains, only: [:index]
    end
  end
end
