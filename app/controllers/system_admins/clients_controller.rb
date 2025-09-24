class SystemAdmins::ClientsController < SystemAdmins::BaseController
  before_action :authenticate_user_admin! 
  before_action :set_client, only: %i[ show edit update destroy ]
  layout 'system_admins'

  def index
    @system_admins_clients = SystemAdmins::Client.all
  end

  # GET /system_admins/clients/1
  def show
  end

  # GET /system_admins/clients/new
  def new
    @system_admins_client = SystemAdmins::Client.new
  end

  # GET /system_admins/clients/1/edit
  def edit
  end

  # POST /system_admins/clients
  def create
    @system_admins_client = SystemAdmins::Client.new(client_params)
    @system_admins_client.plan_id ||= 4 # plano trial

    if @system_admins_client.save
      redirect_to system_admins_clients_path, notice: "Cliente criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_admins/clients/1
  def update
    if @system_admins_client.update(client_params)
      redirect_to system_admins_clients_path, notice: "Cliente atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /system_admins/clients/1
  def destroy
    @system_admins_client.destroy
    redirect_to system_admins_clients_path, status: :see_other, notice: "Cliente excluído com sucesso."
  end

  private

  def set_client
    @system_admins_client = SystemAdmins::Client.find(params[:id])
  end

  def client_params
    params.require(:system_admins_client).permit(
      :razao_social, :company_name, :cnpj, :first_name, :last_name, :cpf,
      :phone, :address, :number_address, :plan_id, :signup_date,
      :first_payment, :last_payment, :first_login, :last_login
    )
  end
end
