# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
    # Inicialize alguns subprodutos vazios (por exemplo, 1 ou 2)
    2.times { @product.product_subproducts.build }
  end

  # POST /products       # etapa 1
  def create
    @product = Product.new(step1_params)
    if @product.save
      render turbo_stream: turbo_stream.replace(
        "product-configurations",
        partial: "products/aggregated_costs",
        locals: { product: @product }
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /products/:id?step=n   # etapas 2,3,4
  def update
    case params[:step].to_s
    when "2"
      if @product.update(step2_params)
        render turbo_stream: turbo_stream.replace(
          "aggregated-costs",
          partial: "products/product_composition",
          locals: { product: @product }
        )
      else
        head :unprocessable_entity
      end
    when "3"
      if @product.update(step3_params)
        render turbo_stream: turbo_stream.replace(
          "product-composition",
          partial: "products/pricing",
          locals: { product: @product }
        )
      else
        head :unprocessable_entity
      end
    else
      head :ok
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html do
        redirect_to products_path,
                    notice: "Produto “#{@product.description}” excluído com sucesso."
      end
      format.turbo_stream do
        # se quiser apagar a linha via Turbo Stream:
        render turbo_stream: turbo_stream.remove(dom_id(@product))
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :description, :brand_id, :weight, :unit_of_measurement,
      :profit_margin_wholesale, :profit_margin_retail, 
      :financial_cost, :sales_channel_cost, :commission_cost, :freight_cost, :storage_cost,
      product_subproducts_attributes: [:id, :subproduct_id, :quantity, :_destroy]
    )
  end

    # strong params por etapa
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

  def step4_params
    {}
  end

  def min(a, b)
    a < b ? a : b
  end
end