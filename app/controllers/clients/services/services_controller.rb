module Clients
  module Services
    class ServicesController < ApplicationController
      include AuthorizationForClients
      before_action :authenticate_user!
      
      before_action :set_service,        only: %i[show edit update destroy]
      before_action :load_collections,   only: %i[new edit create update]

      def index
        @services = Service.all
      end

      def show
      end

      def new
        @service = Services::Service.new
        @service.service_inputs.build
        @professionals = Professional.order(:full_name)
      end

      def edit
        @service = Services::Service.find(params[:id])
        @professionals = Professional.order(:full_name)
      end

      def create
        @service = Service.new(service_params)
        if @service.save
          redirect_to @service, notice: "Serviço criado com sucesso"
        else
          render :new
        end
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
          @service = Services::Service.find(params[:id])
        end

        def load_collections
          @professionals     = Professional.order(:full_name)
          @available_inputs  = Input.order(:name)
          @available_equipments = Equipment.order(:description)
          @available_energies   = Energy.order(:description)
          @available_products   = Product.order(:description)
          @available_subproducts = Subproduct.order(:name)
        end

        # Only allow a list of trusted parameters through.
      def service_params
        params
          .require(:service)
          .permit(
            :description,
            :role_id,
            :professional_id,
            :hourly_rate,
            :total_hours_raw, 
            :total_hours,
            :tax,
            :profit_margin,
            :service_price,  
            :service_items_cost,
            :final_service_price,
            service_inputs_attributes:      %i[id input_id quantity_for_service cost _destroy],
            service_subproducts_attributes: %i[id subproduct_id quantity_for_service cost _destroy],
            service_products_attributes:    %i[id product_id quantity_for_service cost _destroy],
            service_energies_attributes:    %i[id energy_id hours_per_service cost _destroy],
            service_equipments_attributes:  %i[id equipment_id hours_per_service cost _destroy]
          )
      end
    end
  end
end