class SalesTargetsController < ApplicationController
  before_action :set_sales_target, only: %i[ show edit update destroy ]

  # GET /sales_targets or /sales_targets.json
  def index
    @sales_targets = SalesTarget.all
    @sales_target_sum = @sales_targets.sum(:monthly_target)

    today = Date.current
    @sales_target_active_sum = @sales_targets
      .where("start_date <= ? AND end_date >= ?", today, today)
      .sum(:monthly_target)

    @total_fixed_cost = FixedCost.sum(:monthly_cost)
  end

  # GET /sales_targets/1 or /sales_targets/1.json
  def show
    @sales_target = SalesTarget.find(params[:id])
    @sales_target_sum = SalesTarget.sum(:total_fixed_cost)
  end

  # GET /sales_targets/new
  def new
    @sales_target = SalesTarget.new
  end

  # GET /sales_targets/1/edit
  def edit
  end

  # POST /sales_targets or /sales_targets.json
  def create
    @sales_target = SalesTarget.new(sales_target_params)

    respond_to do |format|
      if @sales_target.save
        format.html do
          redirect_to sales_targets_path,
                      notice: "Sales target was successfully created."
        end
        format.json do
          render :index,
                 status: :created,
                 location: sales_targets_path
        end
      else
        format.html do
          render :new, status: :unprocessable_entity
        end
        format.json do
          render json: @sales_target.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /sales_targets/1 or /sales_targets/1.json
def update
  respond_to do |format|
    if @sales_target.update(sales_target_params)
      format.html { redirect_to sales_targets_path, notice: "Sales target foi atualizado com sucesso." }
      format.json { render :show, status: :ok, location: @sales_target }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @sales_target.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /sales_targets/1 or /sales_targets/1.json
  def destroy
    @sales_target.destroy!

    respond_to do |format|
      format.html { redirect_to sales_targets_path, status: :see_other, notice: "Sales target was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_target
      @sales_target = SalesTarget.find(params.expect(:id))
    end

  def sales_target_params
    params
      .require(:sales_target)
      .permit(
        :product_id,
        :total_fixed_cost,
        :monthly_target,
        :start_date,
        :end_date
      )
  end
end
