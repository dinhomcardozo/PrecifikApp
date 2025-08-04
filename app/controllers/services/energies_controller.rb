module Services
  class EnergiesController < ApplicationController
    before_action :set_energy, only: %i[ show edit update destroy ]

    # GET /energies or /energies.json
    def index
      @energies = Energy.all
    end

    # GET /energies/1 or /energies/1.json
    def show
    end

    # GET /energies/new
    def new
      @energy = Energy.new
    end

    # GET /energies/1/edit
    def edit
    end

    # POST /energies or /energies.json
    def create
      @energy = Energy.new(energy_params)

      respond_to do |format|
        if @energy.save
          format.html { redirect_to @energy, notice: "Energy was successfully created." }
          format.json { render :show, status: :created, location: @energy }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @energy.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /energies/1 or /energies/1.json
    def update
      respond_to do |format|
        if @energy.update(energy_params)
          format.html { redirect_to @energy, notice: "Energy was successfully updated." }
          format.json { render :show, status: :ok, location: @energy }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @energy.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /energies/1 or /energies/1.json
    def destroy
      @energy.destroy!

      respond_to do |format|
        format.html { redirect_to energies_path, status: :see_other, notice: "Energy was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_energy
      @energy = Energy.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def energy_params
      params.expect(energy: [ : description, : consume_per_hour ])
    end
  end
end