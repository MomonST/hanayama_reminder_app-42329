class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favorite, only: [:destroy]
  
  def index
    @favorites = current_user.favorites
                            .includes(flower_mountain: [:flower, :mountain])
                            .order(created_at: :desc)
                            .page(params[:page]).per(12)
  end
  
  def show
    #お気に入り詳細
  end

  # 花山の組み合わせのお気に入り切り替え
  def toggle
    @flower_mountain = FlowerMountain.find(params[:flower_mountain_id])
    @favorite = current_user.favorites.find_by(flower_mountain: @flower_mountain)
    
    if @favorite
      @favorite.destroy
      favorited_status = false # お気に入り解除された
      message_text = 'お気に入りから削除しました'
    else
      @favorite = current_user.favorites.create(flower_mountain: @flower_mountain)
      if @favorite.save
        favorited_status = true # お気に入りに追加された
        message_text = 'お気に入りに追加しました'
      else
        # エラーが発生した場合（例：バリデーションエラー）
        favorited_status = false
        message_text = @favorite.errors.full_messages.join(", ") # エラーメッセージを返す
        render json: { success: false, message: message_text }, status: :unprocessable_entity and return
      end
    end
    
    render json: {
      success: true,
      favorited: favorited_status,
      message: message_text,
      favorites_count: @flower_mountain.favorites.count # 更新後のカウント
    }
  end

  # `create` と `destroy` アクションは、もしAjaxで `toggle` を使う場合、
  # 必要に応じてHTMLリダイレクト専用として残す
  def create
    @flower_mountain = FlowerMountain.find(params[:flower_mountain_id])
    @favorite = current_user.favorites.build(flower_mountain: @flower_mountain)
    if @favorite.save
      redirect_back(fallback_location: root_path, notice: 'お気に入りに追加しました')
    else
      redirect_back(fallback_location: root_path, alert: 'お気に入りの追加に失敗しました')
    end
  end
  
  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_back(fallback_location: favorites_path, notice: 'お気に入りから削除しました')
  end

  private

  def set_favorite
    @favorite = current_user.favorites.find(params[:id])
  end
end