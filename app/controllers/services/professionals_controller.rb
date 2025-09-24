module Services
  class ProfessionalsController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    before_action :set_professional, only: %i[ show edit update destroy ]

    # GET /clients/services/professionals
    def index
      @professionals = Services::Professional.where(client_id: current_user_client.client_id)
    end

    # GET /clients/services/professionals/:id
    def show
      respond_to do |format|
        format.html
        format.json { render json: { hourly_rate: @professional.hourly_rate } }
      end
    end
    
    # GET /clients/services/professionals/new
    def new
      @professional = Services::Professional.new
      @roles = Services::Role.where(client_id: current_user_client.client_id)
    end

    # GET /clients/services/professionals/:id/edit
    def edit
      @roles = Services::Role.where(client_id: current_user_client.client_id)
    end

    # POST /clients/services/professionals
    def create
      @professional = Services::Professional.new(professional_params)
      @professional.client_id = current_user_client.client_id

      if @professional.save
        redirect_to clients_services_professionals_path,
                    notice: "Profissional criado com sucesso."
      else
        Rails.logger.info "Erros ao salvar Professional: #{@professional.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/services/professionals/:id
    def update
      if @professional.update(professional_params)
        redirect_to clients_services_professionals_path,
                    notice: "Profissional atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /clients/services/professionals/:id
    def destroy
      @professional.destroy!
      redirect_to clients_services_professionals_path,
                  status: :see_other,
                  notice: "Profissional excluído com sucesso."
    end

    private

    def set_professional
      @professional = Services::Professional.find_by!(
        id: params[:id],
        client_id: current_user_client.client_id
      )
    end

    def professional_params
      params.require(:professional).permit(
        :full_name,
        :role_id,
        :cpf,
        :company_name,
        :cnpj,
        :average_hourly_rate,
        :hourly_rate
      )
    end
  end
end