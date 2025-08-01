class Sales::OrdersController < ApplicationController
  before_action :set_sales_order, only: %i[ show edit update destroy ]

  # GET /sales/orders or /sales/orders.json
  def index
    @sales_orders = Sales::Order.all
  end

  # GET /sales/orders/1 or /sales/orders/1.json
  def show
  end

  # GET /sales/orders/new
  def new
    @sales_order = Sales::Order.new
  end

  # GET /sales/orders/1/edit
  def edit
  end

  # POST /sales/orders or /sales/orders.json
  def create
    @sales_order = Sales::Order.new(sales_order_params)

    respond_to do |format|
      if @sales_order.save
        format.html { redirect_to @sales_order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @sales_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/orders/1 or /sales/orders/1.json
  def update
    respond_to do |format|
      if @sales_order.update(sales_order_params)
        format.html { redirect_to @sales_order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/orders/1 or /sales/orders/1.json
  def destroy
    @sales_order.destroy!

    respond_to do |format|
      format.html { redirect_to sales_orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_order
      @sales_order = Sales::Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sales_order_params
      params.expect(sales_order: [ :sales_quote_id, :status, :placed_at, :total ])
    end
end
