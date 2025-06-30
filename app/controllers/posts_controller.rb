class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:user, :flower, :mountain)
    
    # ソート順
    case params[:sort]
    when "popular"
      @posts = @posts.popular
    else
      @posts = @posts.recent
    end
    
    # 地域でフィルタリング
    @posts = @posts.where(mountain_id: Mountain.find_by(region: params[:region])&.id) if params[:region].present?
    
    # 花でフィルタリング
    @posts = @posts.where(flower_id: params[:flower_id]) if params[:flower_id].present?
    
    @posts = @posts.page(params[:page]).per(12)
  end
  
  def show
    @likes_count = @post.likes.count
    @liked = user_signed_in? && current_user.likes.exists?(post_id: @post.id)
  end
  
  def new
    @post = Post.new
    @flowers = Flower.all
    @mountains = Mountain.all
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: "投稿が作成されました"
    else
      @flowers = Flower.all
      @mountains = Mountain.all
      render :new
    end
  end
  
  def edit
    @flowers = Flower.all
    @mountains = Mountain.all
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      @flowers = Flower.all
      @mountains = Mountain.all
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end

  # --- ここからいいね機能の追加/修正 ---
  def like
    # いいね済みか確認
    if current_user.likes.exists?(post: @post)
      # 既にいいね済みの場合、いいねを解除
      current_user.likes.find_by(post: @post).destroy
      liked = false # いいね解除されたことを示すフラグ
    else
      # まだいいねしていない場合、いいねを作成
      current_user.likes.create(post: @post)
      liked = true # いいねされたことを示すフラグ
    end

    # 最新のいいね数を取得
    likes_count = @post.likes.count

    # JavaScript (Fetch API) からの要求に応えるため、JSON形式でレスポンスを返す
    respond_to do |format|
      format.json { render json: { success: true, liked: liked, likes_count: likes_count } }
    end
  rescue ActiveRecord::RecordNotFound
    # 投稿が見つからない場合のエラーハンドリング
    respond_to do |format|
      format.json { render json: { success: false, message: '投稿が見つかりませんでした' }, status: :not_found }
    end
  rescue => e
    # その他の予期せぬエラーハンドリング
    Rails.logger.error "Like action error: #{e.message}" # エラーをログに出力
    respond_to do |format|
      format.json { render json: { success: false, message: 'エラーが発生しました' }, status: :internal_server_error }
    end
  end
  # --- いいね機能の追加/修正はここまで ---
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:content, :image_url, :flower_id, :mountain_id)
  end
  
  def authorize_user!
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "他のユーザーの投稿は編集できません"
    end
  end
end