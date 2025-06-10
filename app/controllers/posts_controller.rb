class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:user, flower_mountain: [:flower, :mountain])
    
    # ソート順
    case params[:sort]
    when "popular"
      @posts = @posts.popular
    else
      @posts = @posts.recent
    end
    
    # 地域でフィルタリング
    @posts = @posts.joins(flower_mountain: :mountain).where(mountains: { region: params[:region] }) if params[:region].present?
    
    # 花でフィルタリング
    @posts = @posts.joins(flower_mountain: :flower).where(flowers: { id: params[:flower_id] }) if params[:flower_id].present?
    
    @posts = @posts.page(params[:page]).per(12)
  end
  
  def show
    @likes_count = @post.likes.count
    @liked = user_signed_in? && current_user.likes.exists?(post_id: @post.id)
  end
  
  def new
    @post = Post.new
    @flower_mountain_id = params[:flower_mountain_id]
    @flower_mountains = FlowerMountain.includes(:flower, :mountain).all
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: "投稿が作成されました"
    else
      @flower_mountains = FlowerMountain.includes(:flower, :mountain).all
      render :new
    end
  end
  
  def edit
    @flower_mountains = FlowerMountain.includes(:flower, :mountain).all
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      @flower_mountains = FlowerMountain.includes(:flower, :mountain).all
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:flower_mountain_id, :content, :image_url)
  end
  
  def authorize_user!
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "他のユーザーの投稿は編集できません"
    end
  end
end