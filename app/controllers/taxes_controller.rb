class TaxesController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"
  
  before_action :set_tax, only: %i[ show edit update destroy ]

  # GET /taxes or /taxes.json
  def index
    @taxes = Tax.all
  end

  # GET /taxes/1 or /taxes/1.json
  def show
    @tax = Tax.find(params[:id])
    @product_portions = @tax.product_portions.includes(:product)
  end

  # GET /taxes/new
  def new
    @tax = Tax.new
  end

  def edit
    @tax = Tax.find(params[:id])
    @product_portions = @tax.product_portions.includes(:product)
  end

  def create
    @tax = Tax.new(tax_params)

    if @tax.save
      redirect_to taxes_path, notice: "Perfil de impostos criado com sucesso."
    else
      flash.now[:alert] = @tax.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tax.update(tax_params)
      redirect_to taxes_path, notice: "Perfil de impostos atualizado com sucesso."
    else
      flash.now[:alert] = @tax.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tax.destroy!
    redirect_to taxes_path, notice: "Perfil de impostos excluído com sucesso.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tax_params
      params.expect(tax: [ :description, :icms, :ipi, :pis_cofins, :difal, :iss, :cbs, :ibs, :note ])
    end
end
