class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update]
  
  def show
    @posts = @user.posts.recent.includes(:flower, :mountain).limit(6)
    @favorites = @user.favorites.includes(flower_mountain: [:flower, :mountain]).limit(6)
    @notifications = @user.notifications.includes(flower_mountain: [:flower, :mountain]).limit(4)
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました"
    else
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:nickname, :region)
  end
  
  def authorize_user!
    unless @user == current_user
      redirect_to root_path, alert: "他のユーザーのプロフィールは編集できません"
    end
  end
end