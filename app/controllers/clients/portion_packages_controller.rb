module Clients
  class PortionPackagesController < ApplicationController
    before_action :set_portion_package, only: %i[ show edit update destroy ]

    # GET /portion_packages or /portion_packages.json
    def index
      @portion_packages = PortionPackage.all
    end

    # GET /portion_packages/1 or /portion_packages/1.json
    def show
    end

    # GET /portion_packages/new
    def new
      @portion_package = PortionPackage.new
    end

    # GET /portion_packages/1/edit
    def edit
    end

    # POST /portion_packages or /portion_packages.json
    def create
      @portion_package = PortionPackage.new(portion_package_params)

      respond_to do |format|
        if @portion_package.save
          format.html { redirect_to @portion_package, notice: "Portion package was successfully created." }
          format.json { render :show, status: :created, location: @portion_package }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @portion_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /portion_packages/1 or /portion_packages/1.json
    def update
      respond_to do |format|
        if @portion_package.update(portion_package_params)
          format.html { redirect_to @portion_package, notice: "Portion package was successfully updated." }
          format.json { render :show, status: :ok, location: @portion_package }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @portion_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /portion_packages/1 or /portion_packages/1.json
    def destroy
      @portion_package.destroy!

      respond_to do |format|
        format.html { redirect_to portion_packages_path, status: :see_other, notice: "Portion package was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_portion_package
        @portion_package = PortionPackage.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def portion_package_params
        params.expect(portion_package: [ :product_portion_id, :package_id, :package_units, :total_package_price ])
      end
  end
end