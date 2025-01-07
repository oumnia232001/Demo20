# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy] 

  def index
    if params[:query].present?
      @posts = Post.where("title LIKE ? OR content LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%").order("created_at DESC")
    else
      @posts = Post.all.order("created_at DESC")
    end
  end
  

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id  # Assurez-vous d'associer l'utilisateur connecté
  
    if @post.title.present? && @post.content.present? && @post.save
      redirect_to @post
    else
      render 'new'
    end
  end
  

  def show
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path

  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
