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
    else
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
      :use_default_taxes,
      product_subproducts_attributes: %i[
        id subproduct_id quantity cost _destroy
      ],
      product_tax_overrides_attributes: %i[
        id name value tax_type _destroy
      ]
    )
  end
end