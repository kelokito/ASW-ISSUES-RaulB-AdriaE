class IssuesController < ApplicationController
  include IssuesHelper
  before_action :authenticate_user, only: [:create, :destroy]
  before_action :set_issue, only: %i[ show sort edit update destroy dueDate updateDueDate block updateBlock unblock watchers updateWatchers assigned updateAssigned ]
  protect_from_forgery except: [:bulkCreate]
  protect_from_forgery except: [:filter]
  protect_from_forgery except: [:filter_by_name]
  # GET /issues or /issues.json
  def index
    # .order(created_at: :desc) Ordena les issues de més noves a més velles.

  if @issues.nil?
    @issues = Issue.all
  end

   if params[:search]
      #@issues = Issues.where( subject: params[:search])
      @issues = @issues.where("id LIKE ? OR subject LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
   else
   end

  filter
  if params[:sort_by] == 'created_at'
    @issues = @issues.order(created_at: session[:sort_order])

  elsif params[:sort_by] == 'updated_at'
      @issues = @issues.order(updated_at: session[:sort_order])

  elsif params[:sort_by] == 'typeIssue'
      @issues = @issues.order(typeIssue: session[:sort_order])

  elsif params[:sort_by] == 'severityIssue'
      @issues = @issues.order(severityIssue: session[:sort_order])

  elsif params[:sort_by] == 'priorityIssue'
      @issues = @issues.order(priorityIssue: session[:sort_order])

  elsif params[:sort_by] == 'statusIssue'
      @issues = @issues.order(statusIssue: session[:sort_order])

  elsif params[:sort_by] == 'user_id'
      @issues = @issues.order(user_id: session[:sort_order])

    #Configuracio per defecte-> ordre descendent d'issues
  else
        @issues = @issues.order(created_at: :desc)
  end

  # Canviem l'ordre d'ordenació de cara a la proxima iteració
  session[:sort_order] = session[:sort_order] == 'asc' ? 'desc' : 'asc'

  render 'index'

  end

  def filter
    @issues = Issue.all
    if !params[:filter_by_type].nil? && !params[:filter_by_type].empty?
      #@issues = Issues.where( typeIssue: params[:filter_by_type])
      @issues = @issues.where("typeIssue like ?", "#{params[:filter_by_type]}")
    end
    if !params[:filter_by_severity].nil? && !params[:filter_by_severity].empty?
      #@issues = Issues.where( severityIssue: params[:filter_by_severity])
      @issues = @issues.where("severityIssue like ?", "#{params[:filter_by_severity]}")
    end
    if !params[:filter_by_priority].nil? && !params[:filter_by_priority].empty?
      #@issues = Issues.where( priorityIssue: params[:filter_by_priority])
      @issues = @issues.where("priorityIssue like ?", "#{params[:filter_by_priority]}")
    end
    if !params[:filter_by_status].nil? && !params[:filter_by_status].empty?
      #@issues = Issues.where( statusIssue: params[:filter_by_status])
      @issues = @issues.where("statusIssue like ?", "#{params[:filter_by_status]}")
    end
    if !params[:filter_by_assign].nil? && !params[:filter_by_assign].empty?
      @uid = User.find_by(full_name: params[:filter_by_assign]).id
      #@issues = Issues.where( user_id: @uid)
      @issues = @issues.where("user_id like ?", "#{@uid}")
    end
    if !params[:filter_by_createdBy].nil? && !params[:filter_by_createdBy].empty?
      @uid = User.find_by(full_name: params[:filter_by_createdBy]).id
      #@issues = Issues.where( createdBy: @uid)
      @issues = @issues.where("createdBy like ?", "#{@uid}")
    end
    respond_to do |format|
      format.json { render json: @issues}
    end
  end

  def filter_by_name
    if params[:subject]
      @issues = @issues.where("subject like ?", "%#{params[:subject]}%")
    end
  end


  # GET /issues/1 or /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
    @attachment = Attachment.new
  end

  # GET /issues/bulk
  def bulk
    @issue = Issue.new
  end

  def dueDate
  end

  def block
  end

  def watchers
  end

  def assigned
  end

  def updateAssigned
    respond_to do |format|
        usuario = params["Usuario"]
        userId = User.find_by(email: usuario).id
        @userAssigned = Issue.find_by(id: @issue.id, user_id: userId)
        if @userAssigned.nil? then
          raw_parameters = {:user_id => userId}
          @issue.update(raw_parameters)
          format.html { redirect_back fallback_location: root_path, notice: "Issue assigned was successfully updated." }
          format.json { render :edit, status: :ok }
        else
          raw_parameters = {:user_id => nil}
          @issue.update(raw_parameters)
          format.html { redirect_back fallback_location: root_path, notice: "Issue assigned was successfully updated." }
          format.json { render :edit, status: :ok }
        end
      end
  end

  def updateWatchers
      respond_to do |format|
        usuario = params["Usuario"]
        userId = User.find_by(email: usuario).id
        @issueWatchers = Watcher.find_by(issue_id: @issue.id)
        if @issueWatchers.nil? || !Watcher.exists?(issue_id: @issue.id, user_id: userId) then
          @watcher = Watcher.new({:issue_id => @issue.id, :user_id => userId})
          @watcher.save
          format.html { redirect_to issue_watchers_path, notice: "Issue watchers was successfully updated." }
          format.json { render :edit, status: :ok }
        else
          @watcher = Watcher.find_by(:issue_id => @issue.id, :user_id => User.find_by(email: usuario))
          @watcher.destroy
          format.html { render :watchers, status: :unprocessable_entity }
          format.json { render json: @issue.errors, status: :unprocessable_entity }
        end
      end
  end

  def updateBlock
    respond_to do |format|
      if @issue.blocked.nil? || !@issue.blocked then
              raw_parameters = {:blocked => true,:blocked_reason => issue_block_params[:blocked_reason]}
         else
             raw_parameters = {:blocked => false,:blocked_reason => ""}
      end
      if @issue.update(raw_parameters)
        format.html { redirect_to edit_issue_path, notice: "Issue block state was successfully updated." }
        format.json { render :edit, status: :ok }
      else
        format.html { render :block, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def updateDueDate
    respond_to do |format|
      if @issue.update(issue_date_params)
        @issue.save
        format.html { redirect_to edit_issue_path, notice: "Issue due date was successfully updated." }
        format.json { render :edit, status: :ok }
      else
        format.html { render :dueDate, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def bulkCreate
    respond_to do |format|
      format.html do
        @linias = issue_params[:subject].split(/[\n\r]+/).reverse()
        success_count = 0

        @linias.each do |linia|
          u = issue_params.to_h
          u[:subject] = linia
          @issue = Issue.new(u)

          if @issue.save
            success_count += 1
          else
            format.html { render :bulk, status: :unprocessable_entity }
            return
          end
        end

        redirect_to issues_url, notice: "#{success_count} issues were successfully created."
      end

      format.json do
        issues_params = params.require(:issues)
        if issues_params.blank?
          render json: { error: "No issues provided in the request" }, status: :unprocessable_entity
          return
        end

        success_count = 0

        issues_params.each do |issue_params|
          @issue = Issue.new(issue_params.permit(:subject))

          if @issue.save
            success_count += 1
          else
            render json: { error: "Failed to create issue: #{issue_params}" }, status: :unprocessable_entity
            return
          end
        end

        render json: { message: "#{success_count} issues were successfully created." }, status: :ok
      end
    end
  end


  # POST /issues or /issues.json
  def create
    @issue = Issue.new(issue_params)
    usuario=User.first.id
    @issue.createdBy= usuario

    respond_to do |format|
      if @issue.save
        format.html { redirect_to issues_url, notice: "Issue was successfully created." }
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    old_issue_params = @issue.attributes

    respond_to do |format|
      if @issue.update(issue_params)
        @issue.updated_at = Time.zone.now
        new_issue_params = @issue.attributes

        format.html do
          user_id = current_user.id

          # Comprovem nou titol
          if old_issue_params['subject'] != new_issue_params['subject']
            create_activity(user_id, 'Subject Update', "#{old_issue_params['subject']}, changed to: #{new_issue_params['subject']}")
          end

          # Comprovem nova descripcio
          if old_issue_params['description'] != new_issue_params['description']
            create_activity(user_id, 'Description Update', "#{old_issue_params['description']}, changed to: #{new_issue_params['description']}")
          end

          # Comprovem nou tipus
          if old_issue_params['typeIssue'] != new_issue_params['typeIssue']
            types = ["Bug", "Question", "Enhancement", "To do"]
            create_activity(user_id, 'Type Update', "#{types[old_issue_params['typeIssue']]}, changed to: #{types[new_issue_params['typeIssue']]}")
          end

          # Comprovem nova severity
          if old_issue_params['severityIssue'] != new_issue_params['severityIssue']
            severity = ["Wishlist", "Minor", "Normal", "Important", "Critical"]
            create_activity(user_id, 'Severity Update', "#{severity[old_issue_params['severityIssue']]}, changed to: #{severity[new_issue_params['severityIssue']]}")
          end

          # Comprovem nova priority
          if old_issue_params['priorityIssue'] != new_issue_params['priorityIssue']
            priority = ["Low", "Normal", "High"]
            create_activity(user_id, 'Priority Update', "#{priority[old_issue_params['priorityIssue']]}, changed to: #{priority[new_issue_params['priorityIssue']]}")
          end

          # Comprovem nou status
          if old_issue_params['statusIssue'] != new_issue_params['statusIssue']
            status = ["New", "In Progress", "Ready for Test", "Closed", "Needs Info", "Rejected", "Postponed"]
            create_activity(user_id, 'Status Update', "#{status[old_issue_params['statusIssue']]}, changed to: #{status[new_issue_params['statusIssue']]}")
          end

          # Resto de las comprobaciones de actualización...

          redirect_to issues_url, notice: "Issue was successfully updated."
        end

        format.json do
          user_id = getUserByApiKey.id

          # Comprovem nou titol
          if old_issue_params['subject'] != new_issue_params['subject']
            create_activity(user_id, 'Subject Update', "#{old_issue_params['subject']}, changed to: #{new_issue_params['subject']}")
          end

          # Comprovem nova descripcio
          if old_issue_params['description'] != new_issue_params['description']
            create_activity(user_id, 'Description Update', "#{old_issue_params['description']}, changed to: #{new_issue_params['description']}")
          end

          # Comprovem nou tipus
          if old_issue_params['typeIssue'] != new_issue_params['typeIssue']
            types = ["Bug", "Question", "Enhancement", "To do"]
            create_activity(user_id, 'Type Update', "#{types[old_issue_params['typeIssue']]}, changed to: #{types[new_issue_params['typeIssue']]}")
          end

          # Comprovem nova severity
          if old_issue_params['severityIssue'] != new_issue_params['severityIssue']
            severity = ["Wishlist", "Minor", "Normal", "Important", "Critical"]
            create_activity(user_id, 'Severity Update', "#{severity[old_issue_params['severityIssue']]}, changed to: #{severity[new_issue_params['severityIssue']]}")
          end

          # Comprovem nova priority
          if old_issue_params['priorityIssue'] != new_issue_params['priorityIssue']
            priority = ["Low", "Normal", "High"]
            create_activity(user_id, 'Priority Update', "#{priority[old_issue_params['priorityIssue']]}, changed to: #{priority[new_issue_params['priorityIssue']]}")
          end

          # Comprovem nou status
          if old_issue_params['statusIssue'] != new_issue_params['statusIssue']
            status = ["New", "In Progress", "Ready for Test", "Closed", "Needs Info", "Rejected", "Postponed"]
            create_activity(user_id, 'Status Update', "#{status[old_issue_params['statusIssue']]}, changed to: #{status[new_issue_params['statusIssue']]}")
          end

          render :index, status: :ok
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:subject, :description,:statusIssue, :typeIssue, :severityIssue, :priorityIssue)
    end

    def issue_date_params
      params.require(:issue).permit(:due_date)
    end

    def issue_block_params
      params.require(:issue).permit(:blocked_reason)
    end

    def issue_watchers_params
      params.require(:issue).permit(:watchers)
    end

    def create_activity(user_id, action, description)
      Activity.create(user_id: user_id, issue_id: @issue.id, action: action, description: description)
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
