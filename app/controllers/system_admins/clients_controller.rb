class SystemAdmins::ClientsController < ApplicationController
  before_action :authenticate_user_client!
  before_action :set_client, only: %i[ show edit update destroy ]

  validates :cpf, presence: true, format: { with: /\A\d{11}\z/, message: "deve conter 11 números" }

  # GET /system_admins/clients or /system_admins/clients.json
  def index
    @clients = SystemAdmins::Client.all
  end

  # GET /system_admins/clients/1 or /system_admins/clients/1.json
  def show
  end

  # GET /system_admins/clients/new
  def new
    @client = SystemAdmins::Client.new
  end

  # GET /system_admins/clients/1/edit
  def edit
  end

  # POST /system_admins/clients or /system_admins/clients.json
  def create
    @client = current_user_client.build_client(client_params)
    @client.plan_id ||= 4  # plano trial

    if @client.save
      redirect_to root_path, notice: 'Perfil de cliente criado com sucesso.'
    else
      render :new
    end
  end

  # PATCH/PUT /system_admins/clients/1 or /system_admins/clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/clients/1 or /system_admins/clients/1.json
  def destroy
    @client.destroy!

    respond_to do |format|
      format.html { redirect_to clients_path, status: :see_other, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = SystemAdmins::Client.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.expect(client: [ :razao_social, :company_name, :cnpj, :first_name, :last_name, :cpf, :phone, :address, :number_address, :plan_id, :signup_date, :first_payment, :last_payment, :first_login, :last_login ])
    end
end
