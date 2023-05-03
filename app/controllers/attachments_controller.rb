class AttachmentsController < ApplicationController
  before_action :set_issue

  def create
    @attachment = @issue.attachments.create(attachment_params)
    if @attachment.persisted?
      redirect_to edit_issue_path(@issue), notice: 'Attachment created successfully'
    else
      flash.now[:alert] = 'Error creating attachment'
      render 'issues/show'
    end
  end

  def destroy
    @attachment = @issue.attachments.find(params[:id])
    if @attachment.destroy
      redirect_to edit_issue_path(@issue), notice: 'Attachment deleted successfully'
    else
      flash.now[:alert] = 'Error deleting attachment'
      render 'issues/show'
    end
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
