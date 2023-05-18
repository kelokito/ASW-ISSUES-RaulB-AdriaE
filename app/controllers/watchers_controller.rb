class WatchersController < ApplicationController
  before_action :set_watcher, only: %i[ show edit update destroy ]
  before_action :authenticate_user, only: [:create, :destroy]
  protect_from_forgery except: [:create, :destroy]

  # GET /watchers or /watchers.json
  def index
    respond_to do |format|
      format.json do
        issue_id = params[:id]
        watchers = Watcher.where(issue_id: issue_id)
        if watchers.empty?
          render json: { error: "No watchers found for issue_id: #{issue_id}" }, status: :not_found
        else
          render json: watchers
        end
      end
      format.html do
        @watchers = Watcher.all
      end
    end
  end

  # GET /watchers/1 or /watchers/1.json
  def show
  end

  # GET /watchers/new
  def new
    @watcher = Watcher.new
  end

  # GET /watchers/1/edit
  def edit
  end

  # POST /watchers or /watchers.json
  def create
    #comprovacio de Issue exists
    issue_id = params[:issue_id]
    issue = Issue.find_by(id: issue_id)
    if issue.nil?
      render json: { error: "No issue found with id: #{issue_id}" }, status: :not_found
      return
    end
    #comprovacio de User exists
    user_id = params[:user_id]
    user = User.find_by(id: user_id)
    if user.nil?
      render json: { error: "No user found with id: #{user_id}" }, status: :not_found
      return
    end

    @watcher = Watcher.new(watcher_params)

    respond_to do |format|
      if @watcher.save
        format.html { redirect_to watcher_url(@watcher), notice: "Watcher was successfully created." }
        format.json { render :show, status: :created, location: @watcher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @watcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watchers/1 or /watchers/1.json
  def update
    respond_to do |format|
      if @watcher.update(watcher_params)
        format.html { redirect_to watcher_url(@watcher), notice: "Watcher was successfully updated." }
        format.json { render :show, status: :ok, location: @watcher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @watcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watchers/1 or /watchers/1.json
  def destroy
    @watcher.destroy

    respond_to do |format|
      format.html { redirect_to watchers_url, notice: "Watcher was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watcher
      @watcher = Watcher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def watcher_params
      params.require(:watcher).permit(:issue_id, :user_id)
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
