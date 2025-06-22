class SubproductCompositionsController < ApplicationController
  before_action :set_subproduct
  before_action :set_subproduct_composition, only: [:update, :destroy]

  def create
    @subproduct_composition = @subproduct.subproduct_compositions.build(subproduct_composition_params)
    # Se precisar, atribua valores default (por exemplo, quantidade zero ou outro valor aceitável)
    @subproduct_composition.quantity_for_a_unit ||= 0 if @subproduct_composition.quantity_for_a_unit.blank?

    if @subproduct_composition.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("compositions", 
            partial: "subproducts/subproduct_compositions_fields", 
            locals: { subproduct_composition: @subproduct_composition }
          )
        end
        format.html { redirect_to edit_composition_subproduct_path(@subproduct) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("compositions", 
            partial: "subproducts/form_composition", 
            locals: { subproduct: @subproduct }
          )
        end
        format.html { render "subproducts/edit_composition", status: :unprocessable_entity }
      end
    end
  end

  def update
    if @subproduct_composition.update(subproduct_composition_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@subproduct_composition),
            partial: "subproducts/subproduct_compositions_fields", 
            locals: { subproduct_composition: @subproduct_composition }
          )
        end
        format.html { redirect_to edit_composition_subproduct_path(@subproduct) }
      end
    else
      # Aqui você pode tratar erros de validação, por exemplo
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subproduct_composition.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@subproduct_composition))
      end
      format.html { redirect_to edit_composition_subproduct_path(@subproduct) }
    end
  end

  private

  def set_subproduct
    @subproduct = Subproduct.find(params[:subproduct_id])
  end

  def set_subproduct_composition
    @subproduct_composition = @subproduct.subproduct_compositions.find(params[:id])
  end

  def subproduct_composition_params
    params.fetch(:subproduct_composition, {}).permit(:input_id, :quantity_for_a_unit)
  end
end