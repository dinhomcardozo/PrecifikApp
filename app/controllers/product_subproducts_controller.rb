class ProductSubproductsController < ApplicationController
  before_action :set_product

  before_validation :calculate_cost

  def create
    @ps = @product.product_subproducts.create(ps_params)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    @ps = @product.product_subproducts.find(params[:id])
    @ps.update(ps_params)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @ps = @product.product_subproducts.find(params[:id])
    @ps.destroy
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def ps_params
    params.require(:product_subproduct)
          .permit(:subproduct_id, :quantity, :cost)
  end

  def calculate_cost
    if quantity.present? && subproduct&.cost_per_gram.present?
      self.cost = quantity * subproduct.cost_per_gram
    end
  end
end