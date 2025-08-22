class SystemAdmins::ClientPlansController < ApplicationController
  before_action :set_client_plan, only: %i[ show edit update destroy ]

  # GET /system_admins/client_plans or /system_admins/client_plans.json
  def index
    @client_plans = SystemAdmins::ClientPlan.all
  end

  # GET /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def show
  end

  # GET /system_admins/client_plans/new
  def new
    @client_plan = SystemAdmins::ClientPlan.new
  end

  # GET /system_admins/client_plans/1/edit
  def edit
  end

  # POST /system_admins/client_plans or /system_admins/client_plans.json
  def create
    @client_plan = SystemAdmins::ClientPlan.new(client_plan_params)

    respond_to do |format|
      if @client_plan.save
        format.html { redirect_to @client_plan, notice: "Client plan was successfully created." }
        format.json { render :show, status: :created, location: @client_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def update
    respond_to do |format|
      if @client_plan.update(client_plan_params)
        format.html { redirect_to @client_plan, notice: "Client plan was successfully updated." }
        format.json { render :show, status: :ok, location: @client_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def destroy
    @client_plan.destroy!

    respond_to do |format|
      format.html { redirect_to client_plans_path, status: :see_other, notice: "Client plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_plan
      @client_plan = SystemAdmins::ClientPlan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def client_plan_params
      params.expect(client_plan: [ :client_id, :plan_id ])
    end
end
