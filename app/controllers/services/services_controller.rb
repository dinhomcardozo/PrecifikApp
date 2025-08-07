module Services
  class ServicesController < ApplicationController
    before_action :set_service, only: %i[ show edit update destroy ]

    def index
      @services = Service.all
    end

    def show
    end

    def new
      @service = Service.new
      %i[
        service_inputs service_subproducts service_products
        service_energies service_equipments
      ].each { |assoc| @service.send(assoc).build }
      @roles   = Role.all
      @available_inputs = Input.all
    end

    def create
      @service = Service.new(service_params)
      if @service.save
        redirect_to @service, notice: "Service criado com sucesso!"
      else
        render :new
      end
    end


    def edit
    end

    def update
      respond_to do |format|
        if @service.update(service_params)
          format.html { redirect_to @service, notice: "Service was successfully updated." }
          format.json { render :show, status: :ok, location: @service }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @service.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @service.destroy!

      respond_to do |format|
        format.html { redirect_to services_path, status: :see_other, notice: "Service was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_service
        @service = Service.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(
        :description, :role_id, :professional_id,
        :total_hours_raw, :tax, :profit_margin,
        service_inputs_attributes:      %i[id input_id quantity_for_service cost _destroy],
        service_subproducts_attributes: %i[id subproduct_id quantity_for_service cost _destroy],
        service_products_attributes:    %i[id product_id quantity_for_service cost _destroy],
        service_energies_attributes:    %i[id energy_id hours_per_service cost _destroy],
        service_equipments_attributes:  %i[id equipment_id hours_per_service cost _destroy]
      )
    end
  end
end