class FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @favorites = current_user.favorites
                            .includes(flower_mountain: [:flower, :mountain])
                            .order(created_at: :desc)
                            .page(params[:page]).per(12)
  end
  
  def create
    @flower_mountain = FlowerMountain.find(params[:flower_mountain_id])
    @favorite = current_user.favorites.build(flower_mountain: @flower_mountain)
    
    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @flower_mountain, notice: "お気に入りに追加しました" }
        format.js
      else
        format.html { redirect_to @flower_mountain, alert: "お気に入りに追加できませんでした" }
        format.js
      end
    end
  end
  
  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @flower_mountain = @favorite.flower_mountain
    @favorite.destroy
    
    respond_to do |format|
      format.html { redirect_to @flower_mountain, notice: "お気に入りから削除しました" }
      format.js
    end
  end
end