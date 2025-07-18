class InputsController < ApplicationController
  before_action :set_url_options, only: %i[index show]
  before_action :set_input,       only: %i[show edit update]

  def index
    @inputs = Input.all.includes(:supplier, :input_type)
  end

  def show
    respond_to do |format|
      format.html { render layout: false }
      format.json do
        render json: {
          cost:             @input.cost.to_f,
          weight_in_grams:  @input.weight.to_f
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
      redirect_to inputs_path, notice: "Insumo criado com sucesso."
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
      redirect_to inputs_path, notice: "Insumo atualizado com sucesso."
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
      :image
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