class ProductSubproductsController < ApplicationController
  before_action :set_product
  before_action :set_ps, only: %i[update destroy]

  def create
    @ps = @product.product_subproducts.create(ps_params)
    render_partial_line
  end

  def update
    @ps.update(ps_params)
    render_partial_line
  end

  def destroy
    @ps.destroy
    render turbo_stream: turbo_stream.remove(dom_id(@ps))
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_ps
    @ps = @product.product_subproducts.find(params[:id])
  end

  def ps_params
    params.require(:product_subproduct).permit(:subproduct_id, :quantity)
  end

  def render_partial_line
    render partial: "products/product_composition_fields",
           locals: { f: form_builder_for(@ps) }
           # layout:  false
  end

  # gera um form builder compatível com f.fields_for
  def form_builder_for(ps)
    form = ActionView::Helpers::FormBuilder.new(
      :product_subproduct,
      ps,
      view_context,
      { url: product_product_subproduct_path(@product, ps), method: ps.persisted? ? :patch : :post },
      proc {}
    )
    form
  end
end