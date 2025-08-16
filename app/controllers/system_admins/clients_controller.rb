class SystemAdmins::ClientsController < ApplicationController
  before_action :set_system_admins_client, only: %i[ show edit update destroy ]

  # GET /system_admins/clients or /system_admins/clients.json
  def index
    @system_admins_clients = SystemAdmins::Client.all
  end

  # GET /system_admins/clients/1 or /system_admins/clients/1.json
  def show
  end

  # GET /system_admins/clients/new
  def new
    @system_admins_client = SystemAdmins::Client.new
  end

  # GET /system_admins/clients/1/edit
  def edit
  end

  # POST /system_admins/clients or /system_admins/clients.json
  def create
    @system_admins_client = SystemAdmins::Client.new(system_admins_client_params)

    respond_to do |format|
      if @system_admins_client.save
        format.html { redirect_to @system_admins_client, notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/clients/1 or /system_admins/clients/1.json
  def update
    respond_to do |format|
      if @system_admins_client.update(system_admins_client_params)
        format.html { redirect_to @system_admins_client, notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/clients/1 or /system_admins/clients/1.json
  def destroy
    @system_admins_client.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_clients_path, status: :see_other, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_client
      @system_admins_client = SystemAdmins::Client.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_client_params
      params.expect(system_admins_client: [ :razao_social, :company_name, :cnpj, :first_name, :last_name, :cpf, :phone, :address, :number_address, :plan_id, :signup_date, :first_payment, :last_payment, :first_login, :last_login ])
    end
end
