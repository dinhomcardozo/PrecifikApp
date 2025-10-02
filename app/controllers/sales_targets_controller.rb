class SalesTargetsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"
  
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

      # Custo fixo distribuído global por unidade
    @distributed_fixed_cost =
      if @sales_target_sum.zero?
        0
      else
        (@total_fixed_cost / @sales_target_sum).round(2)
      end

    @product_portions_without_sales_target =
      ProductPortion.left_outer_joins(:sales_target)
                    .where(sales_targets: { id: nil })
                    .includes(:product => :category)

    @expected_retail_revenue = @sales_targets
      .where("start_date <= :today AND end_date >= :today", today: today)
      .sum { |st| st.product_portion&.product&.suggested_price_retail.to_f * st.monthly_target.to_i }

    @expected_wholesale_revenue = @sales_targets
      .where("start_date <= :today AND end_date >= :today", today: today)
      .sum { |st| st.product_portion&.product&.suggested_price_wholesale.to_f * st.monthly_target.to_i }
  end

  # GET /sales_targets/1 or /sales_targets/1.json
  def show
    @sales_target = SalesTarget.find(params[:id])

    # Exibe também os totais globais, caso precise
    @sales_target_sum        = @sales_target.sales_target_sum
    @sales_target_active_sum = @sales_target.sales_target_active_sum
    @total_fixed_cost        = FixedCost.sum(:monthly_cost)

    @expected_retail_revenue =
      @sales_target.product_portion&.product&.suggested_price_retail.to_f * @sales_target.monthly_target.to_i

    @expected_wholesale_revenue =
      @sales_target.product_portion&.product&.suggested_price_wholesale.to_f * @sales_target.monthly_target.to_i
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

  def alert_data
    today = Date.current
    vencidas = SalesTarget.where("end_date < ?", today)
    vencendo = SalesTarget.where(end_date: today)

    render json: {
      vencidas: vencidas.map { |st| { product: st.product_portion&.product&.description, dias: (today - st.end_date).to_i.abs } },
      vencendo: vencendo.map { |st| { product: st.product_portion&.product&.description, dias: (st.end_date - today).to_i } }
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_sales_target
    @sales_target = SalesTarget.find(params[:id])
  end

  def sales_target_params
    params.require(:sales_target).permit(
      :product_portion_id,
      :total_fixed_cost,
      :monthly_target,
      :start_date,
      :end_date
    )
  end
end
