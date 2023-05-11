class ActivitiesController < ApplicationController
  before_action :set_issue
  def index
    @issue = Issue.find(params[:issue_id])
    @activities = @issue.activities
    respond_to do |format|
      format.html
      format.json { render json: @activities }
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

end
