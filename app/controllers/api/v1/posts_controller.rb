module Api
  module V1
    class PostsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :show] # 基本的にAPIではセッション認証は不要
      before_action :authenticate_user!, only: [:create] # 例: APIトークン認証を導入する場合,authenticate_user_by_token!
      before_action :set_post, only: [:show]
      
      def index
         @posts = Post.includes(:user, flower_mountain: [:flower, :mountain]).recent
        
        # 検索・フィルタリング
        if params[:search].present?
          @posts = @posts.where("content ILIKE ?", "%#{params[:search]}%")
        end
        
        if params[:flower_id].present?
          @posts = @posts.where(flower_id: params[:flower_id])
        end
        
        if params[:mountain_id].present?
          @posts = @posts.where(mountain_id: params[:mountain_id])
        end
        
        if params[:user_id].present?
          @posts = @posts.where(user_id: params[:user_id])
        end
        
        # ソート
        case params[:sort]
        when 'oldest'
          @posts = @posts.oldest
        when 'popular'
          @posts = @posts.popular
        else
          @posts = @posts.recent
        end
        
        # ページネーション
        @posts = @posts.page(params[:page]).per(params[:per_page] || 20)
        
        render json: {
          posts: @posts.as_json(
            only: [:id, :content, :image_url, :created_at],
            methods: [:likes_count],
            include: {
              user: { only: [:id, :nickname] },
              flower_mountain: {
                include: {
                  flower: { only: [:id, :name] },
                  mountain: { only: [:id, :name, :region] }
                }
              }
            }
          ),
          meta: {
            total_count: @posts.total_count,
            total_pages: @posts.total_pages,
            current_page: @posts.current_page,
            next_page: @posts.next_page,
            prev_page: @posts.prev_page
          }
        }
      end
      
      def show
        render json: {
          post: @post.as_json(
            except: [:updated_at],
            methods: [:likes_count],
            include: {
              user: { only: [:id, :nickname] },
              flower_mountain: {
                include: {
                  flower: { only: [:id, :name, :image_url] },
                  mountain: { only: [:id, :name, :region, :elevation] }
                }
              }
            }
          )
        }
      end
      
      def create
        @post = current_user.posts.new(post_params)
        
        if @post.save
          render json: {
            success: true,
            post: @post.as_json(
              only: [:id, :content, :image_url, :created_at],
              include: {
                user: { only: [:id, :nickname] },
                flower_mountain: {
                  include: {
                    flower: { only: [:id, :name] },
                    mountain: { only: [:id, :name] }
                  }
                }
              }
            )
          }, status: :created
        else
          render json: {
            success: false,
            errors: @post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      private
      
      def set_post
        @post = Post.find(params[:id])
      end
      
      def post_params
        params.require(:post).permit(:content, :image_url, :flower_mountain_id, :taken_at)
      end

      # 例: APIトークン認証のメソッド (実際の認証ロジックはUserモデルや別のconcernで定義)
      def authenticate_user_by_token!
        # リクエストヘッダーからトークンを取得し、ユーザーを認証するロジック
        # raise ActionController::RoutingError, 'Not Found' unless current_user_for_api # 仮のメソッド名
      end
    end
  end
end
