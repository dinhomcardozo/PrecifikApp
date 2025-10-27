class InputsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"
  
  before_action :set_url_options, only: %i[index show]
  before_action :set_input,       only: %i[show edit update]

  def index
    @inputs = Input.all.includes(:supplier, :input_type)
  end

  def show
    set_input
    set_url_options

    # Subprodutos diretos que usam este input
    @subproducts = Subproduct
                    .joins(:subproduct_compositions)
                    .where(subproduct_compositions: { input_id: @input.id })
                    .distinct

    # Serviços diretos que usam este input
    @services = Services::Service
                  .joins(:service_inputs)
                  .where(service_inputs: { input_id: @input.id })
                  .distinct

    # Contagens
    @subproducts_count = @subproducts.count
    @services_count    = @services.count

    # Extrai últimos 12 meses (incluindo mês atual)
    @cost_history = @input.input_cost_histories
                          .where("recorded_at >= ?", 11.months.ago.beginning_of_month)
                          .order(:recorded_at)

    respond_to do |format|
      format.html
      format.json do
        render json: {
              cost:            @input.cost.to_f,
              weight_in_grams: (@input.weight.presence || 1).to_f,
              cost_per_unit:   @input.cost_per_gram.to_f
        }
      end
    end
  end

  def new
    @input = Input.new
  end

  def create
    @input = Input.new(input_params)

    if @input.save
      redirect_to @input, notice: "Insumo criado com sucesso."
    else
      puts "❌ Erro ao criar insumo"
      puts "→ Erros: #{@input.errors.full_messages}"
      puts "→ Params rejeitados: #{input_params.to_h}"
      puts "→ A imagem foi anexada? #{@input.image.attached?}"

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @input = Input.find(params[:id])
  end

  def update
    @input = Input.find(params[:id])

    if @input.update(input_params)
      redirect_to @input, notice: "Insumo atualizado com sucesso."
    else
      puts "❌ Erro ao atualizar insumo"
      puts "→ Erros: #{@input.errors.full_messages}"
      puts "→ Params rejeitados: #{input_params.to_h}"
      puts "→ A imagem foi anexada? #{@input.image.attached?}"

      render :edit, status: :unprocessable_entity
    end
  end

  private

  def input_params
    params.require(:input).permit(
      :name,
      :cost,
      :supplier_id,
      :brand_id,
      :unit_of_measurement,
      :input_type_id,
      :weight,
      :image,
      :total_fat,
      :protein,
      :carbs,
      :dietary_fiber,
      :sugars,
      :sodium,
      :calories,
      :resalable_product,
      :profit_margin,
      :final_cost,
      :selling_price,
      :real_profit_margin
    ).tap do |whitelisted|
      if %w[kg L].include?(whitelisted[:unit_of_measurement])
        whitelisted[:weight] = whitelisted[:weight].to_f * 1000
      end
    end
  end

  def set_url_options
    ActiveStorage::Current.url_options = {
      protocol: request.protocol,
      host:     request.host,
      port:     request.port
    }
  end

  def set_input
    @input = Input.find(params[:id])
  end
end