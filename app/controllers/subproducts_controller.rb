class SubproductsController < ApplicationController
  before_action :set_subproduct, only: %i[show edit update destroy edit_composition update_composition]

  #Actions para criação básica do subproduct antes de ir para subproduct_compositions
  def edit_composition
    unless @subproduct.subproduct_compositions.any?
      3.times { @subproduct.subproduct_compositions.build }
    end
    render 'edit_composition'
  end

  def update_composition
    if @subproduct.update(subproduct_params)
      redirect_to subproducts_path, notice: "Subproduto atualizado com sucesso."
    else
      render :edit_composition, status: :unprocessable_entity
    end
  end

  ####

  def index
    @subproducts = Subproduct.all
  end

  def show
    @compositions = @subproduct.subproduct_compositions.includes(:input)
  end

  def new
    @subproduct = Subproduct.new
    2.times { @subproduct.subproduct_compositions.build }
  end

  def create
    @subproduct = Subproduct.new(subproduct_params)
    
    if @subproduct.save
      respond_to do |format|
        # Se estiver usando Turbo, pode enviar um Turbo Stream que redirecione ou atualize uma frame:
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_container", partial: "subproducts/form_composition", locals: { subproduct: @subproduct }) }
        format.html { redirect_to edit_composition_subproduct_path(@subproduct) }
      end
    else
      render :new
    end
  end

  def edit
    @subproduct.subproduct_compositions.build if @subproduct.subproduct_compositions.empty?
  end

  def update
    if @subproduct.update(subproduct_params)
      redirect_to subproducts_path, notice: "Subproduto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subproduct = Subproduct.find(params[:id])
    @subproduct.subproduct_compositions.destroy_all
    @subproduct.destroy
    redirect_to subproducts_url, notice: "Subproduto excluído com sucesso."
  end

  private

    private

  def set_subproduct
    @subproduct = Subproduct.find(params[:id])
  end

  def subproduct_params
    params.require(:subproduct).permit(
      :name,
      :unit_of_measurement,
      :brand_id,
      :cost,
      :weight_in_grams,
      subproduct_compositions_attributes: [
        :id,
        :input_id,
        :quantity_for_a_unit,
        :_destroy
      ]
    )
  end
end