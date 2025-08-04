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
    end

    def create
      @service = Service.new(service_params)
      if @service.save
        redirect_to services_services_path, notice: "Serviço criado."
      else
        render :new, status: :unprocessable_entity
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
        :description,
        :role_id,
        :total_seconds,
        :tax_percent,
        :profit_margin_percent,
        :final_price
      )
    end
  end
end