class PackageCompositionsController < ApplicationController
  before_action :set_package_composition, only: %i[ show edit update destroy ]

  # GET /package_compositions or /package_compositions.json
  def index
    @package_compositions = PackageComposition.all
  end

  # GET /package_compositions/1 or /package_compositions/1.json
  def show
  end

  # GET /package_compositions/new
  def new
    @package_composition = PackageComposition.new
  end

  # GET /package_compositions/1/edit
  def edit
  end

  # POST /package_compositions or /package_compositions.json
  def create
    @package_composition = PackageComposition.new(package_composition_params)

    respond_to do |format|
      if @package_composition.save
        format.html { redirect_to @package_composition, notice: "Package composition was successfully created." }
        format.json { render :show, status: :created, location: @package_composition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @package_composition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /package_compositions/1 or /package_compositions/1.json
  def update
    respond_to do |format|
      if @package_composition.update(package_composition_params)
        format.html { redirect_to @package_composition, notice: "Package composition was successfully updated." }
        format.json { render :show, status: :ok, location: @package_composition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @package_composition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /package_compositions/1 or /package_compositions/1.json
  def destroy
    @package_composition.destroy!

    respond_to do |format|
      format.html { redirect_to package_compositions_path, status: :see_other, notice: "Package composition was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package_composition
      @package_composition = PackageComposition.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def package_composition_params
      params.expect(package_composition: [ : package_id, : product_id, : weight, : discount, : price, : subprice ])
    end
end
