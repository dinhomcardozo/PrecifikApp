module Services
  class EnergiesController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    
    before_action :set_energy, only: %i[ show edit update destroy ]

    def index
      @energies = Energy.all
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: { cost_per_unit: @energy.consume_per_hour.to_f } }
      end
    end

    def new
      @energy = Energy.new
    end

    def edit
    end

    def create
      @energy = Services::Energy.new(energy_params)
      @energy.client_id = current_user_client.client_id

      if @energy.save
        redirect_to clients_services_energies_path, notice: "Energia criada com sucesso"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      respond_to do |format|
        if @energy.update(energy_params)
          format.html { redirect_to @energy, notice: "Energy was successfully updated." }
          format.json { render :show, status: :ok, location: @energy }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @energy.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @energy.destroy!
      redirect_to clients_services_energies_path, status: :see_other, notice: "Energia removida com sucesso."
    end

    private

    def set_energy
      @energy = Energy.find(params[:id])
    end

    def energy_params
      params.require(:services_energy)
            .permit(:description, :consume_per_hour)
    end
  end
end