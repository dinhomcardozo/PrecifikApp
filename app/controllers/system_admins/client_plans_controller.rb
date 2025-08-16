class SystemAdmins::ClientPlansController < ApplicationController
  before_action :set_system_admins_client_plan, only: %i[ show edit update destroy ]

  # GET /system_admins/client_plans or /system_admins/client_plans.json
  def index
    @system_admins_client_plans = SystemAdmins::ClientPlan.all
  end

  # GET /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def show
  end

  # GET /system_admins/client_plans/new
  def new
    @system_admins_client_plan = SystemAdmins::ClientPlan.new
  end

  # GET /system_admins/client_plans/1/edit
  def edit
  end

  # POST /system_admins/client_plans or /system_admins/client_plans.json
  def create
    @system_admins_client_plan = SystemAdmins::ClientPlan.new(system_admins_client_plan_params)

    respond_to do |format|
      if @system_admins_client_plan.save
        format.html { redirect_to @system_admins_client_plan, notice: "Client plan was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_client_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def update
    respond_to do |format|
      if @system_admins_client_plan.update(system_admins_client_plan_params)
        format.html { redirect_to @system_admins_client_plan, notice: "Client plan was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_client_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_client_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/client_plans/1 or /system_admins/client_plans/1.json
  def destroy
    @system_admins_client_plan.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_client_plans_path, status: :see_other, notice: "Client plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_client_plan
      @system_admins_client_plan = SystemAdmins::ClientPlan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_client_plan_params
      params.expect(system_admins_client_plan: [ :client_id, :plan_id ])
    end
end
