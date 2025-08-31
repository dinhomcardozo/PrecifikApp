module Clients
  module Services
    class ProfessionalsController < ApplicationController
      include AuthorizationForClients
      before_action :authenticate_user!
      
      before_action :set_professional, only: %i[ show edit update destroy ]

      # GET /services/professionals
      def index
        @professionals = Services::Professional.all
      end

      # GET /services/professionals/:id
      def show
        prof = Professional.find(params[:id])
        respond_to do |format|
          format.json { render json: { hourly_rate: prof.hourly_rate } }
        end
      end
      
      # GET /services/professionals/new
      def new
        @professional = Services::Professional.new
      end

      # GET /services/professionals/:id/edit
      def edit
      end

      # POST /services/professionals
      def create
        @professional = Services::Professional.new(professional_params)

        respond_to do |format|
          if @professional.save
            format.html do
              redirect_to services_professionals_path,
                          notice: "Profissional criado com sucesso."
            end
            format.json { head :created, location: services_professionals_url }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json do
              render json: @professional.errors,
                    status: :unprocessable_entity
            end
          end
        end
      end

      # PATCH/PUT /services/professionals/:id
      def update
        respond_to do |format|
          if @professional.update(professional_params)
            format.html do
              redirect_to services_professionals_path,
                          notice: "Profissional atualizado com sucesso."
            end
            format.json { head :ok, location: services_professionals_url }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json do
              render json: @professional.errors,
                    status: :unprocessable_entity
            end
          end
        end
      end

      # DELETE /services/professionals/:id
      def destroy
        @professional.destroy!

        respond_to do |format|
          format.html do
            redirect_to services_professionals_path,
                        status: :see_other,
                        notice: "Profissional excluído com sucesso."
          end
          format.json { head :no_content }
        end
      end

      private

      def set_professional
        @professional = Services::Professional.find(params[:id])
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
end