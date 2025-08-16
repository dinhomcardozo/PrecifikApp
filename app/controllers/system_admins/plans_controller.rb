class SystemAdmins::PlansController < ApplicationController
  before_action :set_system_admins_plan, only: %i[ show edit update destroy ]

  # GET /system_admins/plans or /system_admins/plans.json
  def index
    @system_admins_plans = SystemAdmins::Plan.all
  end

  # GET /system_admins/plans/1 or /system_admins/plans/1.json
  def show
  end

  # GET /system_admins/plans/new
  def new
    @system_admins_plan = SystemAdmins::Plan.new
  end

  # GET /system_admins/plans/1/edit
  def edit
  end

  # POST /system_admins/plans or /system_admins/plans.json
  def create
    @system_admins_plan = SystemAdmins::Plan.new(system_admins_plan_params)

    respond_to do |format|
      if @system_admins_plan.save
        format.html { redirect_to @system_admins_plan, notice: "Plan was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/plans/1 or /system_admins/plans/1.json
  def update
    respond_to do |format|
      if @system_admins_plan.update(system_admins_plan_params)
        format.html { redirect_to @system_admins_plan, notice: "Plan was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/plans/1 or /system_admins/plans/1.json
  def destroy
    @system_admins_plan.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_plans_path, status: :see_other, notice: "Plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_plan
      @system_admins_plan = SystemAdmins::Plan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_plan_params
      params.expect(system_admins_plan: [ :description, :price, :status ])
    end
end
