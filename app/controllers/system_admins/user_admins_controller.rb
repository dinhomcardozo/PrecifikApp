class SystemAdmins::UserAdminsController < ApplicationController
  before_action :set_system_admins_user_admin, only: %i[ show edit update destroy ]

  # GET /system_admins/user_admins or /system_admins/user_admins.json
  def index
    @system_admins_user_admins = SystemAdmins::UserAdmin.all
  end

  # GET /system_admins/user_admins/1 or /system_admins/user_admins/1.json
  def show
  end

  # GET /system_admins/user_admins/new
  def new
    @system_admins_user_admin = SystemAdmins::UserAdmin.new
  end

  # GET /system_admins/user_admins/1/edit
  def edit
  end

  # POST /system_admins/user_admins or /system_admins/user_admins.json
  def create
    @system_admins_user_admin = SystemAdmins::UserAdmin.new(system_admins_user_admin_params)

    respond_to do |format|
      if @system_admins_user_admin.save
        format.html { redirect_to @system_admins_user_admin, notice: "User admin was successfully created." }
        format.json { render :show, status: :created, location: @system_admins_user_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_admins/user_admins/1 or /system_admins/user_admins/1.json
  def update
    respond_to do |format|
      if @system_admins_user_admin.update(system_admins_user_admin_params)
        format.html { redirect_to @system_admins_user_admin, notice: "User admin was successfully updated." }
        format.json { render :show, status: :ok, location: @system_admins_user_admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_admins/user_admins/1 or /system_admins/user_admins/1.json
  def destroy
    @system_admins_user_admin.destroy!

    respond_to do |format|
      format.html { redirect_to system_admins_user_admins_path, status: :see_other, notice: "User admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_admins_user_admin
      @system_admins_user_admin = SystemAdmins::UserAdmin.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_admins_user_admin_params
      params.expect(system_admins_user_admin: [ :full_name, :email, :phone, :admin ])
    end
end
