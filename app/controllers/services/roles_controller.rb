module Services
  class RolesController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    before_action :set_role, only: %i[ show edit update destroy ]

    # GET /clients/services/roles
    def index
      @roles = Services::Role.where(client_id: current_user_client.client_id)
    end

    # GET /clients/services/roles/new
    def new
      @role = Services::Role.new
    end

    # GET /clients/services/roles/:id/edit
    def edit; end

    # POST /clients/services/roles
    def create
      @role = Services::Role.new(role_params)
      @role.client_id = current_user_client.client_id

      if @role.save
        redirect_to clients_services_roles_path,
                    notice: "Função criada com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/services/roles/:id
    def update
      if @role.update(role_params)
        redirect_to clients_services_roles_path,
                    notice: "Função atualizada com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /clients/services/roles/:id
    def destroy
      @role.destroy!
      redirect_to clients_services_roles_path,
                  status: :see_other,
                  notice: "Função excluída com sucesso."
    end

    private

    def set_role
      @role = Services::Role.find_by!(
        id: params[:id],
        client_id: current_user_client.client_id
      )
    end

    def role_params
      params.require(:services_role).permit(:description)
    end
  end
end
