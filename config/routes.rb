Rails.application.routes.draw do
  # Deviseのユーザー認証関連のルーティング
  devise_for :users

  # Homeページのルーティング
  root to: 'home#index'

  # 静的ページ
  get 'about', to: 'home#about'

  # Usersの編集・表示関連
  resources :users, only: [:show, :edit, :update]

  # 花関連のルート
  resources :flowers, only: [:index, :show]
  
  # 山関連のルート
  resources :mountains, only: [:index, :show]

  # FlowerMountainsのリソースをRESTfulに設定(トップレベルのshow, indexは残し、favoriteもここに集約)
  resources :flower_mountains, only: [:index, :show] do
    member do
      post :favorite # /flower_mountains/:id/favorite
    end
  end
  
  # --- ここから posts と likes のルーティングを統合・整理 ---
  resources :posts do
    # 投稿のいいね/いいね解除のトグルアクション (POST /posts/:id/like)
    member do
      post :like
    end
    # 投稿へのいいね作成 (POST /posts/:post_id/likes)
    resources :likes, only: [:create]
  end

  # いいねの削除 (DELETE /likes/:id) は単独のリソースとして定義
  resources :likes, only: [:destroy]
  # --- posts と likes のルーティング統合はここまで ---

  # 通知関連
  resources :notifications, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      delete :clear_all
    end
  end

  # お気に入りリソース (FlowerMountainへのいいねとは別に、ユーザーのお気に入り管理ならこのまま)
  resources :favorites, only: [:index, :show, :create, :destroy] do
    collection do
      post 'toggle/:flower_mountain_id', to: 'favorites#toggle', as: :toggle
    end
  end


  # API
  namespace :api do
    namespace :v1 do
      resources :flower_mountains, only: [:index]
      #resources :flowers, only: [:index]
      #resources :mountains, only: [:index]
      resources :posts, only: [:index, :create, :show]
    end
  end
end
