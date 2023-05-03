class CommentsController < ApplicationController
  before_action :set_issue

  #create a new comment for the issue from the curretn_user
  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.create(comment_params)
    @comment.user_id = current_user.id

    if !@comment.save
      render 'issues/edit', alert: 'Error adding comment'
    end

    redirect_to edit_issue_path(@issue), notice: 'Comment added successfully'
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end


  def comment_params
    params
      .require(:comment)
      .permit(:content)
  end
end