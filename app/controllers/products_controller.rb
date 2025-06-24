# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  def new
    @product = Product.new
    # Inicialize alguns subprodutos vazios (por exemplo, 1 ou 2)
    2.times { @product.product_subproducts.build }
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Produto criado com sucesso."
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(
      :description, :brand_id, :weight, :unit_of_measurement,
      :profit_margin_wholesale, :profit_margin_retail, 
      :financial_cost, :sales_channel_cost, :commission_cost, :freight_cost, :storage_cost,
      product_subproducts_attributes: [:id, :subproduct_id, :quantity, :_destroy]
    )
  end
end