class CommentsController < ApplicationController
  before_action :set_issue

  #create a new comment for the issue from the curretn_user
  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.create(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to edit_issue_path(@issue), notice: 'Comment added successfully'}
        format.json { render json: @comment, status: :created }
      else
        format.html { render 'issues/edit', alert: 'Error adding comment' }
        format.json { render json: { error: 'Failed to create comment' }, status: :unprocessable_entity }
      end
    end
  end

  def index
    @issue = Issue.find(params[:issue_id])
    @comments = @issue.comments
    respond_to do |format|
      format.html
      format.json { render json: @comments }
    end
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:issue_id])
    unless @issue
      respond_to do |format|
        format.html { redirect_to issues_path, alert: 'Issue not found' }
        format.json { render json: { error: 'Issue not found' }, status: :not_found }
      end
    end
  end


  def comment_params
    params
      .require(:comment)
      .permit(:content)
  end
end