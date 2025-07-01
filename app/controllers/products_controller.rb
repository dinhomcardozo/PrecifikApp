# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: %i[ edit update show destroy ]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    2.times { @product.product_subproducts.build }
  end

  def edit
    build_subproducts
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Produto criado com sucesso"
    else
      build_subproducts
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Produto atualizado com sucesso"
    else
      build_subproducts
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produto excluído"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def build_subproducts
    # garante pelo menos 2 linhas
    (2 - @product.product_subproducts.size).times do
      @product.product_subproducts.build
    end
  end

  def product_params
    params.require(:product).permit(
      :description, :brand_id,
      :profit_margin_wholesale, :profit_margin_retail,
      :financial_cost, :sales_channel_cost,
      :commission_cost, :freight_cost, :storage_cost,
      product_subproducts_attributes: %i[
        id subproduct_id quantity cost _destroy
      ]
    )
  end
end