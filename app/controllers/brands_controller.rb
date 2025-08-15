class BrandsController < ApplicationController
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

  private

  def brand_params
    params.require(:brand).permit(:name, :main_brand)
  end
end