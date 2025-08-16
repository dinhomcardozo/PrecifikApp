class SystemAdmins::UserClientsController < ApplicationController
  before_action :set_system_admins_user_client, only: %i[ show edit update destroy ]

  # GET /system_admins/user_clients or /system_admins/user_clients.json
  def index
    @system_admins_user_clients = SystemAdmins::UserClient.all
  end

  # GET /system_admins/user_clients/1 or /system_admins/user_clients/1.json
  def show
  end

  # GET /system_admins/user_clients/new
  def new
    @system_admins_user_client = SystemAdmins::UserClient.new
  end

  # GET /system_admins/user_clients/1/edit
  def edit
  end

  # POST /system_admins/user_clients or /system_admins/user_clients.json
  def create
    @system_admins_user_client = SystemAdmins::UserClient.new(system_admins_user_client_params)

    respond_to do |format|
      if @system_admins_user_client.save
        format.html { redirect_to @system_admins_user_client, notice: "User client was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_user_client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/user_clients/1 or /system_admins/user_clients/1.json
  def update
    respond_to do |format|
      if @system_admins_user_client.update(system_admins_user_client_params)
        format.html { redirect_to @system_admins_user_client, notice: "User client was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_user_client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/user_clients/1 or /system_admins/user_clients/1.json
  def destroy
    @system_admins_user_client.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_user_clients_path, status: :see_other, notice: "User client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_user_client
      @system_admins_user_client = SystemAdmins::UserClient.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_user_client_params
      params.expect(system_admins_user_client: [ :user_id, :client_id ])
    end
end
