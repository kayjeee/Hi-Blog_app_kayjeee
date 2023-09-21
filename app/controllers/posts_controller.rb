class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: %i[index show]
  load_and_authorize_resource :user
  load_and_authorize_resource :post, through: :user, except: %i[index show new create]

  def index
    @posts = @user.posts
  end

  def show
    @post = @user.posts.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      flash[:notice] = 'Post created successfully.'
      redirect_to user_post_path(current_user, @post)
    else
      render 'new'
    end
  end

  def edit
    # CanCanCan has already loaded and authorized the @post instance variable
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully.'
      redirect_to user_post_path(current_user, @post)
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post deleted successfully.'
    redirect_to user_posts_path(current_user)
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
