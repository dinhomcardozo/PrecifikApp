class Sales::ClientsController < ApplicationController
  before_action :set_sales_client, only: %i[ show edit update destroy ]

  # GET /sales/clients or /sales/clients.json
  def index
    @sales_clients = Sales::Client.all
  end

  # GET /sales/clients/1 or /sales/clients/1.json
  def show
  end

  # GET /sales/clients/new
  def new
    @sales_client = Sales::Client.new
  end

  # GET /sales/clients/1/edit
  def edit
  end

  # POST /sales/clients or /sales/clients.json
  def create
    @sales_client = Sales::Client.new(sales_client_params)

    respond_to do |format|
      if @sales_client.save
        format.html { redirect_to @sales_client, notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @sales_client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/clients/1 or /sales/clients/1.json
  def update
    respond_to do |format|
      if @sales_client.update(sales_client_params)
        format.html { redirect_to @sales_client, notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/clients/1 or /sales/clients/1.json
  def destroy
    @sales_client.destroy!

    respond_to do |format|
      format.html { redirect_to sales_clients_path, status: :see_other, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_client
      @sales_client = Sales::Client.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sales_client_params
      params.expect(sales_client: [ :first_name, :last_name, :company, :cnpj, :phone, :email, :address, :number_address, :city, :state, :country ])
    end
end
