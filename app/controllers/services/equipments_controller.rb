module Services
  class EquipmentsController < ApplicationController
    before_action :set_equipment, only: %i[show edit update destroy]

    # GET /services/equipments
    def index
      @equipments = Services::Equipment.all
    end

    # GET /services/equipments/:id
    def show
    end

    # GET /services/equipments/new
    def new
      @equipment = Services::Equipment.new
    end

    # GET /services/equipments/:id/edit
    def edit
    end

    def create
      @equipment = Services::Equipment.new(equipment_params)
      if @equipment.save
        redirect_to services_equipments_path, notice: "Equipamento criado!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /services/equipments/:id
    def update
      respond_to do |format|
        if @equipment.update(equipment_params)
          format.html do
            redirect_to services_equipments_path,
                        notice: "Equipamento atualizado com sucesso."
          end
          format.json { head :ok, location: services_equipments_url }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json do
            render json: @equipment.errors,
                   status: :unprocessable_entity
          end
        end
      end
    end

    # DELETE /services/equipments/:id
    def destroy
      @equipment.destroy!

      respond_to do |format|
        format.html do
          redirect_to services_equipments_path,
                      status: :see_other,
                      notice: "Equipamento excluído com sucesso."
        end
        format.json { head :no_content }
      end
    end

    private

    def set_equipment
      @equipment = Services::Equipment.find(params[:id])
    end

    def equipment_params
      params.require(:services_equipment)
            .permit(:description, :value, :depreciation_percent, :depreciation_value)
    end
  end
end