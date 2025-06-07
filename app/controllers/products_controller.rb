# app/controllers/products_controller.rb

class ProductsController < ApplicationController
  def new
    @product = Product.new
    2.times { @product.product_subproducts.build } # Adiciona 2 campos vazios
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
      :description, :unit_of_measurement, :tax, :financial_cost,
      :total_weight, :total_cost, :profit_margin_retail, :profit_margin_wholesale,
      product_subproducts_attributes: [:id, :subproduct_id, :quantity, :_destroy]
    )
  end
end