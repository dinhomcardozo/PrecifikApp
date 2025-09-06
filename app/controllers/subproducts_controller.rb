class SubproductsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  
  include Filterable
  
  before_action :set_subproduct, only: %i[edit update destroy]

  def index
    @subproducts = Subproduct.includes(:subproduct_compositions).all
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
      redirect_to subproducts_path, notice: "Criado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @subproduct.update(subproduct_params)
      redirect_to subproducts_path, notice: "Atualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @subproduct = Subproduct.find(params[:id])

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

  def set_subproduct
    @subproduct = Subproduct.find(params[:id])
  end

  def subproduct_params
    params.require(:subproduct).permit(
      :name, :brand_id, :weight_loss,
      subproduct_compositions_attributes: %i[
        id input_id quantity_for_a_unit quantity_cost _destroy
      ]
    )
  end
end