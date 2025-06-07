class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def new
    @supplier = Supplier.new
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to suppliers_path, notice: "Fornecedor criado com sucesso."
    else
      render :new
    end
  end

  def update
    @supplier = Supplier.find(params[:id])

    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: "Fornecedor atualizado com sucesso."
    else
      render :edit
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name)
  end
end