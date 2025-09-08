module Services
  class ServicesController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    
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
      @service.hourly_rate ||= @service.professional&.hourly_rate
    end

    def create
      @service = Services::Service.new(service_params)
      set_role_from_professional
      @service.client_id = current_user_client.client_id

      if @service.save
        redirect_to clients_services_service_path(@service),
                    notice: "Serviço criado com sucesso"
      else
        Rails.logger.info "Erros ao salvar Service: #{@service.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    end

    def update
      Rails.logger.debug ">>> RAW NESTED: #{params[:services_service][:service_subproducts_attributes].inspect}"
      Rails.logger.debug ">>> PERMIT ALL: #{service_params[:service_subproducts_attributes].inspect}"

      @service = Services::Service.find(params[:id])
      set_role_from_professional
      @service.client_id = current_user_client.client_id

      if @service.update(service_params)
        redirect_to clients_services_service_path(@service),
                    notice: "Serviço atualizado com sucesso"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @service.destroy!

      respond_to do |format|
        format.html { redirect_to clients_services_services_path,
              status: :see_other,
              notice: "Serviço excluído com sucesso." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_service
        @service = Services::Service.find(params[:id])
      end

      def set_role_from_professional
        if @service.professional_id.present?
          @service.role_id = Professional.find(@service.professional_id).role_id
        end
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
        params.require(:services_service).permit!  # <–– aceita tudo
      end

      # def service_params
      #   params.require(:services_service).permit(
      #     :description,
      #     :professional_id,
      #     :hourly_rate,
      #     :total_hours_raw,
      #     :total_hours,
      #     :tax,
      #     :profit_margin,
      #     :service_price,
      #     :service_items_cost,
      #     :final_service_price,
      #     service_inputs_attributes: [
      #       :id, :input_id, :quantity_for_service, :cost, :_destroy
      #     ],
      #     service_subproducts_attributes: [
      #       :id, :subproduct_id, :quantity_for_service, :cost, :_destroy
      #     ],
      #     service_products_attributes: [
      #       :id, :product_id, :quantity_for_service, :cost, :_destroy
      #     ],
      #     service_energies_attributes: [
      #       :id, :energy_id, :hours_per_service, :cost, :_destroy
      #     ],
      #     service_equipments_attributes: [
      #       :id, :equipment_id, :hours_per_service, :cost, :_destroy
      #     ]
      #   )
      # end
  end
end