# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  
  def index
    @products = Product.all
  end

  # GET /products/new
  def new
    @product = Product.new
    2.times { @product.product_subproducts.build }
  end

  # POST /products  — Etapa 1
  def create
    @product = Product.new(step1_params)
    if @product.save
      render partial: "products/aggregated_costs",
             locals: { product: @product },
             layout:  false
    else
      render partial: "products/product_configurations",
             locals: { product: @product },
             status:  :unprocessable_entity,
             layout:  false
    end
  end


  # PATCH /products/:id?step=n — Etapas 2 e 3
  def update
    case params[:step]
    when "2"
      if @product.update(step2_params)
        render partial: "products/product_composition",
               locals: { product: @product },
               layout:  false
      else
        render partial: "products/aggregated_costs",
               locals: { product: @product },
               status:  :unprocessable_entity,
               layout:  false
      end
    when "3"
      if @product.update(step3_params)
        render partial: "products/pricing",
               locals: { product: @product },
               layout:  false
      else
        render partial: "products/product_composition",
               locals: { product: @product },
               status:  :unprocessable_entity,
               layout:  false
      end
    else
      head :bad_request
    end
  end


  # GET /products/:id
  def show
    # @product já vem do set_product
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_path, notice: "Produto excluído com sucesso." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@product)) }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def step1_params
    params.require(:product).permit(
      :description, :brand_id, :weight,
      :profit_margin_wholesale, :profit_margin_retail
    )
  end

  def step2_params
    params.require(:product).permit(
      :financial_cost, :sales_channel_cost,
      :commission_cost, :freight_cost, :storage_cost
    )
  end

  def step3_params
    params.require(:product).permit(
      product_subproducts_attributes: %i[id subproduct_id quantity _destroy]
    )
  end
end