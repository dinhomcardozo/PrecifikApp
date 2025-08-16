class SystemAdmins::UsersController < ApplicationController
  before_action :set_system_admins_user, only: %i[ show edit update destroy ]

  # GET /system_admins/users or /system_admins/users.json
  def index
    @system_admins_users = SystemAdmins::User.all
  end

  # GET /system_admins/users/1 or /system_admins/users/1.json
  def show
  end

  # GET /system_admins/users/new
  def new
    @system_admins_user = SystemAdmins::User.new
  end

  # GET /system_admins/users/1/edit
  def edit
  end

  # POST /system_admins/users or /system_admins/users.json
  def create
    @system_admins_user = SystemAdmins::User.new(system_admins_user_params)

    respond_to do |format|
      if @system_admins_user.save
        format.html { redirect_to @system_admins_user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/users/1 or /system_admins/users/1.json
  def update
    respond_to do |format|
      if @system_admins_user.update(system_admins_user_params)
        format.html { redirect_to @system_admins_user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/users/1 or /system_admins/users/1.json
  def destroy
    @system_admins_user.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_user
      @system_admins_user = SystemAdmins::User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_user_params
      params.expect(system_admins_user: [ :first_name, :last_name, :email, :phone, :admin, :client_id, :company_id ])
    end
end
