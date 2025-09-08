module Services
  class RolesController < ApplicationController
    include AuthorizationForClients
    before_action :authenticate_user_client!
    
    before_action :set_role, only: %i[ show edit update destroy ]

    # GET /services/roles
    def index
      @roles = Services::Role.all
    end

    # GET /services/roles/new
    def new
      @role = Services::Role.new
    end

    # GET /services/roles/:id/edit
    def edit
    end

    # POST /services/roles
    def create
      @role = Services::Role.new(role_params)

      respond_to do |format|
        if @role.save
          format.html { redirect_to clients_services_roles_path,
                        notice: "Função criada com sucesso." }
          format.json { render :index,
                        status: :created,
                        location: clients_services_roles_url }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @role.errors,
                                status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /services/roles/:id
    def update
      respond_to do |format|
        if @role.update(role_params)
          format.html { redirect_to clients_services_roles_path,
                        notice: "Função atualizada com sucesso." }
          format.json { render :index,
                        status: :ok,
                        location: clients_services_roles_url }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @role.errors,
                                status: :unprocessable_entity }
        end
      end
    end

    # DELETE /services/roles/:id
    def destroy
      @role.destroy!

      respond_to do |format|
        format.html { redirect_to clients_services_roles_path,
                      status: :see_other,
                      notice: "Função excluída com sucesso." }
        format.json { head :no_content }
      end
    end

    private

    def set_role
      @role = Services::Role.find(params[:id])
    end

    def role_params
      params.require(:services_role).permit(:description)
    end
  end
end