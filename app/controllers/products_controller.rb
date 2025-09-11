# app/controllers/products_controller.rb
class ProductsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  after_action  :verify_authorized
  
  include Filterable

  before_action :init_product, only: %i[new create]
  before_action :set_product, only: %i[show edit update destroy]
  before_action :build_subproducts, only: %i[new edit]
  before_action :set_sales_target_active_sum, only: %i[edit update]
  before_action :set_main_brands, only: %i[new edit create update]

  def index      
      authorize Product, policy_class: Clients::BasePolicy
      @products = Product.all

      if params[:subproduct_name].present?
        @products = @products
          .joins(:subproducts)
          .where("subproducts.name ILIKE ?", "%#{params[:subproduct_name]}%")
      end

      if params[:input_name].present?
        @products = @products
          .joins(:inputs)
          .where("inputs.name ILIKE ?", "%#{params[:input_name]}%")
      end

      if params[:brand_name].present?
        @products = @products
          .joins(:brand)
          .where("brands.main_brand ILIKE ?", "%#{params[:brand_name]}%")
      end
    
    @products = @products
        .order("#{sort_column} #{sort_direction}")
        .includes(:sales_target)
        .yield_self { |rel| apply_filters(rel) }
        .paginate(page: params[:page])
  end

  def new
    authorize Product, policy_class: Clients::BasePolicy
    @product = Product.new
    @main_brands = Brand.main_brands.order(:name)
    2.times { @product.product_subproducts.build }
  end

  def create
    authorize Product, policy_class: Clients::BasePolicy
    @product = Product.new(product_params)
    @product.client_id = current_user_client.client_id

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
    authorize Product, policy_class: Clients::BasePolicy
    if @product.update(product_params)
        if params[:finalize]
          redirect_to product_path(@product), notice: "Produto finalizado com sucesso"
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

  def edit
    authorize Product, policy_class: Clients::BasePolicy
    @main_brands = Brand.main_brands.order(:name)
  end

  def show
    authorize Product, policy_class: Clients::BasePolicy
    @product = Product.find(params[:id])

    # Serviços diretos que usam este produto
    @services = Services::Service
                  .joins(:service_products)
                  .where(service_products: { product_id: @product.id })
                  .distinct

    # Contagem
    @services_count = @services.count

    respond_to do |format|
      format.html # mantém o comportamento atual
    format.json { render json: { cost_per_unit: @product.cost_per_gram.to_f } }
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produto excluído"
  end

  def search
    term = params[:q].to_s.strip
    results = Product
      .where("name ILIKE :t OR description ILIKE :t", t: "%#{term}%")
      .order(:name)
      .limit(20)
      .pluck(:id, :name)
      .map { |id, name| { id: id, text: name } }

    render json: results
  end

  private

  def init_product
    @product = Product.new
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def build_subproducts
    @product.product_subproducts.build if @product.product_subproducts.empty?
  end

  def set_sales_target_active_sum
    @sales_target_active_sum =
      SalesTarget
        .where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
        .sum(:monthly_target)
  end

  def set_main_brands
    @main_brands = Brand.main_brands.order(:name)
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
        cost_per_gram_with_loss
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

  def sortable_columns
  %w[
    products.description
    total_cost_with_taxes
    suggested_price_retail
    suggested_price_wholesale
    # adicione outras colunas numéricas ou textuais aqui
  ]
end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "products.created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end