class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy, :edit]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    if @comment.save
      redirect_to post_path(@post), notice: 'Comment added successfully.'
    else
      redirect_to post_path(@post), alert: 'Failed to add comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: 'Comment deleted successfully.'
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Comment updated successfully.'
    else
      render 'edit'
    end
  end

	def edit
		unless @comment
			redirect_to post_path(@post), alert: "Comment not found."
		end
	end
	

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post
      redirect_to root_path, alert: "Post not found."
    end
  end

  def set_comment
		if @post
			@comment = @post.comments.find_by(id: params[:id])
		end
	
		unless @comment
			redirect_to post_path(@post), alert: "Comment not found."
		end
	end
	

  def comment_params
    params.require(:comment).permit(:name, :comment)
  end
end
