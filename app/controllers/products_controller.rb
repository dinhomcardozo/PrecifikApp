# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: %i[edit update show destroy]
  before_action :build_subproducts, only: %i[edit update]
  before_action :set_sales_target_active_sum, only: %i[edit update]

  def index
    @products = Product.includes(:sales_target).all
  end

  def new
    @product = Product.new
    2.times { @product.product_subproducts.build }
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      @next_tab = "composition"      # após config, vai direto pra composition
      respond_to do |format|
        format.turbo_stream        # renderiza create.turbo_stream.erb
        format.html do
          redirect_to edit_product_path(
                        @product,
                        active_tab: "composition"
                      )
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
        if params[:finalize]
          respond_to do |format|
            format.turbo_stream { redirect_to product_path(@product) }
            format.html        { redirect_to @product, notice: "Produto finalizado com sucesso" }
          end
        else
        # fluxo original de Avançar entre abas
        @next_tab =
          case params[:active_tab]
          when "config"      then "composition"
          when "composition" then "pricing"
          else                       "config"
          end

        respond_to do |format|
          format.turbo_stream      # renderiza update.turbo_stream.erb
          format.html do
            redirect_to edit_product_path(
                          @product,
                          active_tab: params[:active_tab]
                        ),
                        notice: "Atualizado com sucesso"
          end
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit; end

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
    # garante pelo menos 2 linhas no form
    (2 - @product.product_subproducts.size).times do
      @product.product_subproducts.build
    end
  end

  def set_sales_target_active_sum
    @sales_target_active_sum =
      SalesTarget
        .where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
        .sum(:monthly_target)
  end

  def product_params
    params.require(:product).permit(
      :description,
      :brand_id,
      :category_id,
      :image,
      :tax_id,
      :profit_margin_wholesale,
      :profit_margin_retail,
      :total_cost_with_taxes,
      :suggested_price_retail,
      :suggested_price_wholesale,
      :weight_loss,
      product_subproducts_attributes: %i[
        id
        subproduct_id
        quantity
        cost
        _destroy
      ],
      product_tax_overrides_attributes: %i[
        id
        name
        value
        tax_type
        _destroy
      ]
    )
  end
end