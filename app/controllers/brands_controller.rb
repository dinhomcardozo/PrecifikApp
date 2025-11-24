class BrandsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  layout "application"

  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params.merge(client_id: Current.user_client.client_id))

    if @brand.save
      respond_to do |format|
        format.turbo_stream   # usa create.turbo_stream.erb (fluxo do modal de Inputs)
        format.html { redirect_to brands_path, notice: "Marca criada com sucesso." } # fluxo normal
      end
    else
      respond_to do |format|
        format.turbo_stream do
          # re-renderiza o modal com erros
          render turbo_stream: turbo_stream.replace(
            "new_brand_modal_body",
            partial: "brands/new_modal",
            locals: { brand: @brand }
          )
        end
        format.html do
          flash.now[:alert] = @brand.errors.full_messages.to_sentence
          render :new, status: :unprocessable_entity
        end
      end
    end
  end
  
  def update
    if @brand.update(brand_params)
      respond_to do |format|
        # ✅ Fluxo da página de Marcas: usa update.turbo_stream.erb
        format.turbo_stream
        # ✅ Fallback para HTML normal
        format.html { redirect_to brands_path, notice: "Marca atualizada com sucesso." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@brand), partial: "brands/form", locals: { brand: @brand }) }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def destroy
    @brand.destroy
    redirect_to brands_path, notice: "Marca excluída com sucesso."
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :main_brand)
  end

  def search
    brands = Brand
               .where("name ILIKE ?", "%#{params[:q]}%")
               .order(:name)
               .limit(20)

    render json: brands.map { |b| { id: b.name, name: b.name } }
  end

  def set_brand
    @brand = Brand.find(params[:id])
  end
end