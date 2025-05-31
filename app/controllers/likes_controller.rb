class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.build(post: @post)
    
    respond_to do |format|
      if @like.save
        format.html { redirect_to @post }
        format.js
      else
        format.html { redirect_to @post }
        format.js { render status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @like = current_user.likes.find(params[:id])
    @post = @like.post
    @like.destroy
    
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
end