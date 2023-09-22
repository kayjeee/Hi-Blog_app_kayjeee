class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: %i[index show]
  load_and_authorize_resource :user
  load_and_authorize_resource :post, through: :user, except: %i[index show new create]

  def index
    page = params[:page] || 1
    per_page = 10

    @posts = Post.includes(:author)
      .includes(:comments)
      .where(author: params[:user_id])
      .order(created_at: :asc)
      .offset((page.to_i - 1) * per_page)
      .limit(per_page)

    @total_pages = (@user.posts.count.to_f / per_page).ceil
    @author = @posts.first.author unless @posts.first.nil?
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
