class SystemAdmins::PlansController < ApplicationController
  before_action :set_plan, only: %i[ show edit update destroy ]

  # GET /system_admins/plans or /system_admins/plans.json
  def index
    @plans = SystemAdmins::Plan.all
  end

  def show
  end

  def new
    @plan = SystemAdmins::Plan.new
  end

  def edit
  end

  def create
    @plan = SystemAdmins::Plan.new(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: "Plano criado com sucesso." }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: "Plan was successfully updated." }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan.destroy!

    respond_to do |format|
      format.html { redirect_to plans_path, status: :see_other, notice: "Plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def admins_plan
      @plan = SystemAdmins::Plan.find(params.expect(:id))
    end

    def plan_params
      params.expect(plan: [ :description, :price, :status ])
    end
end
