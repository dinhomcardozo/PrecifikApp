class SubproductsController < ApplicationController
  before_action :set_subproduct, only: %i[show edit update destroy edit_composition update_composition]

  #Actions para criação básica do subproduct antes de ir para subproduct_compositions
  def edit_composition
    @subproduct = Subproduct.find(params[:id])
    unless @subproduct.subproduct_compositions.any?
      3.times { @subproduct.subproduct_compositions.build }
    end
    render 'edit_composition'
  end

  def update_composition
    @subproduct = Subproduct.find(params[:id])

    if @subproduct.update(subproduct_params)
      redirect_to subproducts_path, notice: "Subproduto atualizado com sucesso."
    else
      render :edit_composition
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
    @subproduct = Subproduct.new(subproduct_params.except(:subproduct_compositions_attributes))

    if @subproduct.save
      redirect_to edit_composition_subproduct_path(@subproduct)
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
      render :edit
    end
  end

  def destroy
    @subproduct = Subproduct.find(params[:id])
    @subproduct.subproduct_compositions.destroy_all # ← exclui todas as composições associadas
    @subproduct.destroy
    redirect_to subproducts_url, notice: "Subproduto excluído com sucesso."
  end


  private

  def set_subproduct
    @subproduct = Subproduct.find(params[:id])
  end

  def subproduct_params
    params.require(:subproduct).permit(
      :name,
      :unit_of_measurement,
      :brand_id,
      subproduct_compositions_attributes: [
        :id,
        :input_id,
        :quantity_for_a_unit,
        :_destroy
      ]
    )
  end
end