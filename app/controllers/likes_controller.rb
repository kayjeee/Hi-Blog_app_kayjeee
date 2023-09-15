class LikesController < ApplicationController
    before_action :find_post, only: [:create, :destroy]
  
    def create
      @like = @post.likes.new
      @like.author = current_user
      @like.save
      redirect_to user_post_path(@post.user, @post)
    end
  
    def destroy
      @like = @post.likes.find_by(author: current_user)
      @like&.destroy
      redirect_to user_post_path(@post.user, @post)
    end
  
    private
  
    def find_post
      @post = Post.find(params[:post_id])
    end
  end
  