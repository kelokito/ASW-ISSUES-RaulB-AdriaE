class CommentsController < ApplicationController
  before_action :set_issue
  #before_action :authenticate_user, only: [:create]
  #create a new comment for the issue from the curretn_user
  protect_from_forgery except: [:create]

  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.create(comment_params)
    respond_to do |format|
      format.html do
        @comment.user_id = current_user.id
      end
      format.json do
        @comment.user_id = getUserByApiKey.id
      end
    end

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

    def getUserByApiKey
      api_key = extract_api_key(request.headers['Authorization'])
      @user = User.find_by(api_key: api_key)
      return @user
    end

    def authenticate_user
      if !api_key_present?
        render json: { error: 'API key is missing' }, status: :unauthorized
        return
      end
      api_key = extract_api_key(request.headers['Authorization'])

      #verificamos si la apikey corresponde a un user
      @user = User.find_by(api_key: api_key)

      unless @user
        render json: { error: 'User not found' }, status: :unauthorized
        return
      end
    end

    def extract_api_key(authorization_header)
      return nil if authorization_header.blank?

      token = authorization_header.split(' ').last
      token.strip! unless token.nil?

      token
    end

    def api_key_present?
      !request.headers['Authorization'].blank?
    end

end