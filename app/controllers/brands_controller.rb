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
    @brand = Brand.new(brand_params)
    @brand.client_id = current_user_client.client_id

    puts params[:brand].inspect

    if @brand.save
      redirect_to brands_path, notice: "Marca criada com sucesso."
    else
      render :new
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    puts params[:brand].inspect

    if @brand.update(brand_params)
      redirect_to brands_path, notice: "Marca atualizada com sucesso."
    else
      render :edit
    end
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