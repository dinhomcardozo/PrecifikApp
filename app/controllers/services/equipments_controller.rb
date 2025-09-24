module Services
  class EquipmentsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    before_action :set_equipment, only: %i[show edit update destroy]

    # GET /clients/services/equipments
    def index
      @equipments = Services::Equipment.where(client_id: current_user_client.client_id)
    end

    # GET /clients/services/equipments/:id
    def show
      respond_to do |format|
        format.html
        format.json { render json: { cost_per_unit: @equipment.depreciation_value.to_f } }
      end
    end

    # GET /clients/services/equipments/new
    def new
      @equipment = Services::Equipment.new
    end

    # GET /clients/services/equipments/:id/edit
    def edit; end

    # POST /clients/services/equipments
    def create
      @equipment = Services::Equipment.new(equipment_params)
      @equipment.client_id = current_user_client.client_id

      if @equipment.save
        redirect_to clients_services_equipments_path, notice: "Equipamento criado!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/services/equipments/:id
    def update
      if @equipment.update(equipment_params)
        redirect_to clients_services_equipments_path,
                    notice: "Equipamento atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /clients/services/equipments/:id
    def destroy
      @equipment.destroy!
      redirect_to clients_services_equipments_path,
                  status: :see_other,
                  notice: "Equipamento excluído com sucesso."
    end

    private

    def set_equipment
      @equipment = Services::Equipment.find_by!(
        id: params[:id],
        client_id: current_user_client.client_id
      )
    end

    def equipment_params
      params.require(:services_equipment)
            .permit(:description, :value, :depreciation_percent)
    end
  end
end