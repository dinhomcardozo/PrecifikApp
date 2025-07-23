# app/controllers/tax_profiles_controller.rb
class TaxProfilesController < ApplicationController
  before_action :set_tax_profile, only: %i[show edit update destroy]

  # GET /tax_profiles
  def index
    @tax_profiles = TaxProfile.all
  end

  # GET /tax_profiles/1
  def show
  end

  # GET /tax_profiles/new
  def new
    @tax_profile = TaxProfile.new
    build_default_items
  end

  # GET /tax_profiles/1/edit
  def edit
    build_default_items
  end

  # POST /tax_profiles
  def create
    @tax_profile = TaxProfile.new(tax_profile_params)

    if @tax_profile.save
      redirect_to @tax_profile, notice: "Perfil de tributos criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tax_profiles/1
  def update
    if @tax_profile.update(tax_profile_params)
      redirect_to @tax_profile, notice: "Perfil de tributos atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tax_profiles/1
  def destroy
    @tax_profile.destroy
    redirect_to tax_profiles_url, notice: "Perfil de tributos excluído com sucesso."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tax_profile
    @tax_profile = TaxProfile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tax_profile_params
    params.require(:tax_profile).permit(
      :description, :active, :default,
      items_attributes: %i[id name value tax_type _destroy]
    )
  end

  def build_default_items
    %w[icms ipi pis_cofins difal iss cbs ibs].each do |tax_name|
      @tax_profile.items.build(name: tax_name) unless
        @tax_profile.items.exists?(name: tax_name)
    end
  end
end