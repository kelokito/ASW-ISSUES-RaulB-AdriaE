class IssueUserModificationsController < ApplicationController
  before_action :set_issue_user_modification, only: %i[ show edit update destroy ]

  # GET /issue_user_modifications or /issue_user_modifications.json
def index
  @issue_user_modifications = IssueUserModification.all
end




  # GET /issue_user_modifications/1 or /issue_user_modifications/1.json
  def show
  end

  # GET /issue_user_modifications/new
  def new
    @issue_user_modification = IssueUserModification.new
  end

  # GET /issue_user_modifications/1/edit
  def edit
  end

  # POST /issue_user_modifications or /issue_user_modifications.json
  def create
    @issue_user_modification = IssueUserModification.new(issue_user_modification_params)

    respond_to do |format|
      if @issue_user_modification.save
        format.html { redirect_to issue_user_modification_url(@issue_user_modification), notice: "Issue user modification was successfully created." }
        format.json { render :show, status: :created, location: @issue_user_modification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue_user_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_user_modifications/1 or /issue_user_modifications/1.json
  def update
    respond_to do |format|
      if @issue_user_modification.update(issue_user_modification_params)
        format.html { redirect_to issue_user_modification_url(@issue_user_modification), notice: "Issue user modification was successfully updated." }
        format.json { render :show, status: :ok, location: @issue_user_modification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue_user_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_user_modifications/1 or /issue_user_modifications/1.json
  def destroy
    @issue_user_modification.destroy

    respond_to do |format|
      format.html { redirect_to issue_user_modifications_url, notice: "Issue user modification was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def index
    @issue_user_modifications = IssueUserModification.all
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_user_modification
      @issue_user_modification = IssueUserModification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_user_modification_params
      params.require(:issue_user_modification).permit(:issue_id, :user_id, :modificated_type, :created_at)
    end
end
