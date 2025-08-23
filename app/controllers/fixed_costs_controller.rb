class FixedCostsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  
  before_action :set_fixed_cost, only: %i[ show edit update destroy ]

  # GET /fixed_costs or /fixed_costs.json
  def index
    @fixed_costs = FixedCost.all
  end

  # GET /fixed_costs/1 or /fixed_costs/1.json
  def show
  end

  # GET /fixed_costs/new
  def new
    @fixed_cost = FixedCost.new
  end

  # GET /fixed_costs/1/edit
  def edit
  end

  # POST /fixed_costs or /fixed_costs.json
  def create
    @fixed_cost = FixedCost.new(fixed_cost_params)

    respond_to do |format|
      if @fixed_cost.save
        format.html { redirect_to @fixed_cost, notice: "Fixed cost was successfully created." }
        format.json { render :show, status: :created, location: @fixed_cost }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fixed_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fixed_costs/1 or /fixed_costs/1.json
  def update
    respond_to do |format|
      if @fixed_cost.update(fixed_cost_params)
        format.html { redirect_to @fixed_cost, notice: "Fixed cost was successfully updated." }
        format.json { render :show, status: :ok, location: @fixed_cost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fixed_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixed_costs/1 or /fixed_costs/1.json
  def destroy
    @fixed_cost.destroy!

    respond_to do |format|
      format.html { redirect_to fixed_costs_path, status: :see_other, notice: "Fixed cost was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_fixed_cost
    @fixed_cost = FixedCost.find(params.expect(:id))
  end

  def fixed_cost_params
    params
      .require(:fixed_cost)
      .permit(:description, :monthly_cost, :fixed_cost_type)
  end
end
