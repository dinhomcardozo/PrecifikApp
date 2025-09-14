class ProductionSimulationsController < ApplicationController
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
    if @production_simulation.update(production_simulation_params)
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
              layout: "pdf"
      end
    end
  end

  private

  def set_production_simulation
    @production_simulation = ProductionSimulation.find(params[:id])
  end

  def production_simulation_params
    params.require(:production_simulation).permit(
      :product_id,
      :quantity_in_grams,
      simulation_inputs_attributes: %i[id input_id total_quantity total_cost required_units _destroy],
      simulation_subproducts_attributes: %i[id subproduct_id total_quantity total_cost _destroy],
      simulation_products_attributes: %i[id product_id total_quantity total_cost minimum_selling_price total_selling_price total_retail_profit total_wholesale_profit _destroy]
    )
  end
end