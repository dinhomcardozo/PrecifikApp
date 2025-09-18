class ProductionSimulationsController < ApplicationController
  before_action :authorize_admin!, only: [:destroy]
  before_action :set_production_simulation, only: %i[show edit update destroy]

  def index
    @production_simulations = ProductionSimulation.all
  end

  def new
    @production_simulation = ProductionSimulation.new
  end

  def create
    @production_simulation = ProductionSimulation.new(production_simulation_params)
    @production_simulation.client = Current.user_client.client
    @production_simulation.created_by = Current.user_client

    if @production_simulation.save
      redirect_to @production_simulation, notice: "Simulação criada com sucesso."
    else
      render :new
    end
  end

  def update
    @production_simulation.updated_by = Current.user_client

    @production_simulation.simulation_inputs.destroy_all
    @production_simulation.simulation_subproducts.destroy_all
    @production_simulation.simulation_products.destroy_all

    if @production_simulation.update(production_simulation_params)
      @production_simulation.calculate_totals
      @production_simulation.save
      redirect_to @production_simulation, notice: "Simulação atualizada com sucesso."
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @production_simulation.destroy
    redirect_to production_simulations_path, notice: "Simulação excluída."
  end

  def production_sheet
    @production_simulation = ProductionSimulation.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "production_sheet_#{@production_simulation.id}",
              template: "production_simulations/production_sheet",
              formats: [:html],
              layout: "pdf"
      end
    end
  end

  def calculate
    I18n.locale = :'pt-BR'
    product = Product.includes(product_subproducts: { subproduct: { subproduct_compositions: :input } })
                    .find_by(id: params[:product_id])

    product_units = params[:product_units].to_f
    quantity_in_grams = product_units * product.final_weight.to_f

    if product.nil? || product_units <= 0
      render json: { inputs: [], subproducts: [], product: {} }
      return
    end

    subproducts_data = []
    inputs_data = []

    # Peso total do produto final (somando todos os subprodutos)
    peso_total_produto_final = product.product_subproducts.sum do |psp|
      sub = psp.subproduct
      sub ? (psp.quantity.to_f * sub.weight_in_grams.to_f) : 0
    end

    product.product_subproducts.each do |psp|
      subproduct = psp.subproduct
      next unless subproduct

      peso_total_subproduto_no_produto = psp.quantity.to_f * subproduct.weight_in_grams.to_f
      proportion = peso_total_produto_final > 0 ? peso_total_subproduto_no_produto / peso_total_produto_final : 0

      total_quantity_subproduct = quantity_in_grams * proportion
      total_cost_subproduct = (psp.cost_per_gram_with_loss || 0) * total_quantity_subproduct

      subproducts_data << {
        id: subproduct.id,
        name: subproduct.name.to_s,
        total_quantity: total_quantity_subproduct.round(2),
        total_cost: view_context.number_to_currency(total_cost_subproduct),
        total_cost_raw: total_cost_subproduct.round(2)
      }

      # Inputs (via subproduct_compositions)
      subproduct.subproduct_compositions.each do |spc|
        input = spc.input
        next unless input

        proportion_input = subproduct.weight_in_grams.to_f > 0 ? spc.quantity_cost.to_f / subproduct.weight_in_grams.to_f : 0
        total_quantity_input = total_quantity_subproduct * proportion_input
        total_cost_input = (input.cost_per_gram || 0) * total_quantity_input
        required_units = input.weight.to_f > 0 ? (total_quantity_input / input.weight) : 0

        inputs_data << {
          id: input.id,
          name: input.name.to_s,
          total_quantity: total_quantity_input.round(2),
          total_cost: view_context.number_to_currency(total_cost_input),
          total_cost_raw: total_cost_input.round(2),
          required_units: required_units.round(3)
        }
      end
    end

    total_quantity_product = subproducts_data.sum { |sp| sp[:total_quantity] }
    total_cost_product     = subproducts_data.sum { |sp| sp[:total_cost_raw] }

    # Lucro absoluto em R$ usando os valores prontos do produto
    retail_profit_value    = (product.net_profit_retail || 0) * product_units
    wholesale_profit_value = (product.net_profit_wholesale || 0) * product_units
    
    product_data = {
      total_quantity: total_quantity_product.round(2),
      total_cost: view_context.number_to_currency(total_cost_product),
      total_cost_raw: total_cost_product.round(2),
      product_units: product_units.round(2),
      minimum_selling_price: view_context.number_to_currency(product.suggested_price_wholesale || 0),
      minimum_selling_price_raw: (product.suggested_price_wholesale || 0).round(2),
      total_selling_price: view_context.number_to_currency(product_units * (product.suggested_price_wholesale || 0)),
      total_selling_price_raw: (product_units * (product.suggested_price_wholesale || 0)).round(2),
      total_retail_profit: view_context.number_to_currency(retail_profit_value),
      total_retail_profit_raw: retail_profit_value.round(2),

      total_wholesale_profit: view_context.number_to_currency(wholesale_profit_value),
      total_wholesale_profit_raw: wholesale_profit_value.round(2)
    }

    render json: { inputs: inputs_data, subproducts: subproducts_data, product: product_data }
  end

    private

    def set_production_simulation
      @production_simulation = ProductionSimulation.find(params[:id])
    end

    def production_simulation_params
      params.require(:production_simulation).permit(
        :product_id,
        :quantity_in_grams,
        :product_units,
        simulation_inputs_attributes: %i[id input_id total_quantity total_cost required_units _destroy],
        simulation_subproducts_attributes: %i[id subproduct_id total_quantity total_cost _destroy],
        simulation_products_attributes: %i[id product_id total_quantity total_cost minimum_selling_price total_selling_price total_retail_profit total_wholesale_profit _destroy]
      )
    end

    private

    def authorize_admin!
      unless Current.user_client&.admin?
        redirect_to clients_production_simulations_path,
                    alert: "Você não tem permissão para excluir simulações."
      end
    end
  end