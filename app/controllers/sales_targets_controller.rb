class SalesTargetsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  
  before_action :set_sales_target, only: %i[ show edit update destroy ]

  # GET /sales_targets or /sales_targets.json
  def index
    @sales_targets = SalesTarget.all

    # Soma total de todas as metas
    @sales_target_sum = @sales_targets.sum(:monthly_target)

    # Soma total de metas ativas hoje
    today = Date.current
    @sales_target_active_sum =
      @sales_targets
        .where("start_date <= :today AND end_date >= :today", today: today)
        .sum(:monthly_target)

    # Custo fixo total
    @total_fixed_cost = FixedCost.sum(:monthly_cost)
  end

  # GET /sales_targets/1 or /sales_targets/1.json
  def show
    @sales_target = SalesTarget.find(params[:id])

    # Exibe também os totais globais, caso precise
    @sales_target_sum        = @sales_target.sales_target_sum
    @sales_target_active_sum = @sales_target.sales_target_active_sum
    @total_fixed_cost        = FixedCost.sum(:monthly_cost)
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

    if @sales_target.save
      redirect_to sales_targets_path,
                  notice: "Meta de venda criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sales_targets/1 or /sales_targets/1.json
def update
  if @sales_target.update(sales_target_params)
    redirect_to sales_targets_path,
                notice: "Meta de venda atualizada com sucesso."
  else
    render :edit, status: :unprocessable_entity
  end
end

  # DELETE /sales_targets/1 or /sales_targets/1.json
  def destroy
    @sales_target.destroy
    redirect_to sales_targets_path,
                notice: "Meta de venda excluída com sucesso."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_sales_target
    @sales_target = SalesTarget.find(params[:id])
  end

  def sales_target_params
    params.require(:sales_target).permit(
      :product_id,
      :total_fixed_cost,
      :monthly_target,
      :start_date,
      :end_date
    )
  end
end
