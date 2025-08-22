class SubproductCompositionsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user!
  
  before_action :set_subproduct
  before_action :set_composition, only: [:update, :destroy]

  # POST /subproducts/:subproduct_id/composition
  def create
    @composition = @subproduct.subproduct_compositions.build(composition_params)

    respond_to do |format|
      if @composition.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(
              "compositions",
              partial: "subproducts/subproduct_compositions_fields",
              locals: { subproduct_composition: @composition }
            ),
            turbo_stream.replace(
              "subproduct_total_cost",
              partial: "subproducts/total_composition_cost",
              locals: { subproduct: @subproduct }
            )
          ]
        end
        format.html { redirect_to composition_subproduct_path(@subproduct) }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "compositions",
            partial: "subproducts/form_composition",
            locals: { subproduct: @subproduct }
          ), status: :unprocessable_entity
        end
        format.html { render :edit_composition, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /subproducts/:subproduct_id/composition/:id
  def update
    respond_to do |format|
      if @composition.update(composition_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              dom_id(@composition),
              partial: "subproducts/subproduct_compositions_fields",
              locals: { subproduct_composition: @composition }
            ),
            turbo_stream.replace(
              "subproduct_total_cost",
              partial: "subproducts/total_composition_cost",
              locals: { subproduct: @subproduct }
            )
          ]
        end
        format.html { redirect_to composition_subproduct_path(@subproduct) }
      else
        format.html { render :edit_composition, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subproducts/:subproduct_id/composition/:id
  def destroy
    @composition.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(dom_id(@composition)),
          turbo_stream.replace(
            "subproduct_total_cost",
            partial: "subproducts/total_composition_cost",
            locals: { subproduct: @subproduct }
          )
        ]
      end
      format.html { redirect_to composition_subproduct_path(@subproduct) }
    end
  end

  private

  def set_subproduct
    @subproduct = Subproduct.find(params[:subproduct_id])
  end

  def set_composition
    @composition = @subproduct.subproduct_compositions.find(params[:id])
  end

  def composition_params
    params.require(:subproduct_composition)
          .permit(:input_id, :quantity_for_a_unit)
  end
end