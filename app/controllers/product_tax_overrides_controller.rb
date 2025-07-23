class ProductTaxOverridesController < ApplicationController
  before_action :set_product_tax_override, only: %i[ show edit update destroy ]

  # GET /product_tax_overrides or /product_tax_overrides.json
  def index
    @product_tax_overrides = ProductTaxOverride.all
  end

  # GET /product_tax_overrides/1 or /product_tax_overrides/1.json
  def show
  end

  # GET /product_tax_overrides/new
  def new
    @product_tax_override = ProductTaxOverride.new
  end

  # GET /product_tax_overrides/1/edit
  def edit
  end

  # POST /product_tax_overrides or /product_tax_overrides.json
  def create
    @product_tax_override = ProductTaxOverride.new(product_tax_override_params)

    respond_to do |format|
      if @product_tax_override.save
        format.html { redirect_to @product_tax_override, notice: "Product tax override was successfully created." }
        format.json { render :show, status: :created, location: @product_tax_override }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_tax_override.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_tax_overrides/1 or /product_tax_overrides/1.json
  def update
    respond_to do |format|
      if @product_tax_override.update(product_tax_override_params)
        format.html { redirect_to @product_tax_override, notice: "Product tax override was successfully updated." }
        format.json { render :show, status: :ok, location: @product_tax_override }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_tax_override.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_tax_overrides/1 or /product_tax_overrides/1.json
  def destroy
    @product_tax_override.destroy!

    respond_to do |format|
      format.html { redirect_to product_tax_overrides_path, status: :see_other, notice: "Product tax override was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_tax_override
      @product_tax_override = ProductTaxOverride.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_tax_override_params
      params.expect(product_tax_override: [ :product_id, :name, :value, :tax_type ])
    end
end
