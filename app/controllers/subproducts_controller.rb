class SubproductsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"
  
  include Filterable
  
  before_action :set_subproduct, only: %i[edit update destroy]

  def index
    @subproducts = Subproduct.includes(:subproduct_compositions).all

    # search, order and paginate
    if params[:q].present?
      @subproducts = @subproducts.where("subproducts.name ILIKE ?", "%#{params[:q]}%")
    end

    @subproducts = @subproducts.order("#{sort_column} #{sort_direction}")

    @subproducts = @subproducts.paginate(page: params[:page])
  end

  def new
    @subproduct = Subproduct.new
    @subproduct.subproduct_compositions.build
  end

  def edit
    @subproduct.subproduct_compositions.build if @subproduct.subproduct_compositions.empty?
  end

  def create
    @subproduct = Subproduct.new(subproduct_params)
    if @subproduct.save
      redirect_to subproducts_path, notice: "Subproduto criado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @subproduct.update(subproduct_params)
      redirect_to subproducts_path, notice: "Subproduto atualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @subproduct = Subproduct.find(params[:id])
    @compositions = @subproduct.subproduct_compositions.includes(:input)
    @nutritional_summary = @subproduct.nutritional_summary

    # Products diretos que usam este subproduto
    @products = Product
                  .joins(:product_subproducts)
                  .where(product_subproducts: { subproduct_id: @subproduct.id })
                  .distinct

    # Services diretos que usam este subproduto
    @services = Services::Service
                  .joins(:service_subproducts)
                  .where(service_subproducts: { subproduct_id: @subproduct.id })
                  .distinct

    # Contagens
    @products_count = @products.count
    @services_count = @services.count

    respond_to do |format|
      format.html
      format.json { render json: { cost_per_unit: @subproduct.cost_per_gram.to_f } }
    end
  end

  def destroy
    @subproduct.destroy
    redirect_to subproducts_path, notice: "Excluído"
  end

  def search
    @subproducts = Subproduct
      .where("name ILIKE ?", "%#{params[:q]}%")
      .limit(10)

    render json: @subproducts.map { |s| { id: s.id, text: s.name } }
  end

  private

  def sortable_columns
    %w[
      subproducts.name
      subproducts.cost
      subproducts.weight_in_grams
    ]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "subproducts.created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def set_subproduct
    @subproduct = Subproduct.find(params[:id])
  end

  def subproduct_params
    params.require(:subproduct).permit(
      :name, :brand_id, :weight_loss,
      subproduct_compositions_attributes: %i[
        id input_id quantity_for_a_unit quantity_cost require_units _destroy
      ]
    )
  end
end