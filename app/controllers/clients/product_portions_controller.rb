module Clients
  class ProductPortionsController < ApplicationController
    before_action :set_product_portion, only: %i[ show edit update destroy ] 

    # GET /product_portions or /product_portions.json
    def index
      @product_portions = ProductPortion.all
    end

    # GET /product_portions/1 or /product_portions/1.json
    def show
      @product_portion = ProductPortion.find(params[:id])
      @product = @product_portion.product
      @nutritional_summary = @product.nutritional_summary
      @editing_custom_price = params[:edit_custom_price].present?
      @channels = Channel.all.order(:description)
      @channel_rows = @channels.map { |ch| @product_portion.channel_row_for(ch) }
    end

    # GET /product_portions/new
    def new
      @product_portion = ProductPortion.new
      @product_portion.portion_packages.build
      @taxes = Tax.all
    end

    # GET /product_portions/1/edit
    def edit
      @product_portion = ProductPortion.find(params[:id])
      @product_portion.portion_packages.build if @product_portion.portion_packages.empty?
      @taxes = Tax.all
    end

    # POST /product_portions or /product_portions.json
    def create
      Rails.logger.debug params.inspect
      @product_portion = ProductPortion.new(product_portion_params)

      respond_to do |format|
        if @product_portion.save
          format.html { redirect_to @product_portion, notice: "Product portion was successfully created." }
          format.json { render :show, status: :created, location: @product_portion }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product_portion.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /product_portions/1 or /product_portions/1.json
    def update
      @product_portion = ProductPortion.find(params[:id])
      if @product_portion.update(product_portion_params)
        redirect_to @product_portion, notice: "Porção atualizada."
      else
        @channels = Channel.all
        @channel_rows = @channels.map { |ch| @product_portion.channel_row_for(ch) }
        render :show, status: :unprocessable_entity
      end
    end

    # DELETE /product_portions/1 or /product_portions/1.json
    def destroy
      @product_portion.destroy!

      respond_to do |format|
        format.html { redirect_to product_portions_path, status: :see_other, notice: "Product portion was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_portion
      @product_portion = ProductPortion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_portion_params
      params.require(:product_portion).permit(
        :product_id,
        :tax_id,
        :portioned_quantity,
        :final_package_price,
        :profit_margin,
        :custom_final_price,
        portion_packages_attributes: [
          :id,
          :package_id,
          :package_units,
          :total_package_price,
          :_destroy
        ],
        channel_product_portions_attributes: [
          :id,
          :channel_id,
          :corrected_final_price,
          :_destroy
        ]
      )
    end
  end
end