module Services
  class ServicesController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    
    before_action :set_service,        only: %i[show edit update destroy]
    before_action :load_collections,   only: %i[new edit create update]

    def index
      @services = Services::Service.where(client_id: current_user_client.client_id)
    end

    def show
    end

    def new
      @service = Services::Service.new
      @service.service_inputs.build
    end

    def edit
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
        @professionals = Services::Professional
                   .where(client_id: current_user_client.client_id)
                   .order(:full_name)
        @available_inputs  = Input.order(:name)
        @available_equipments = Services::Equipment.where(client_id: current_user_client.client_id).order(:description)
        @available_energies   = Services::Energy.where(client_id: current_user_client.client_id).order(:description)
        @available_product_portions = ProductPortion.includes(:product).order(:id)
        @available_subproducts = Subproduct.order(:name)
      end

      # Only allow a list of trusted parameters through.
      def service_params
        params.require(:services_service).permit!
      end
  end
end