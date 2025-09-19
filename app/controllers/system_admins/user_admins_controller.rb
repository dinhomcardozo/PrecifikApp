class SystemAdmins::UserAdminsController < ApplicationController
  before_action :set_user_admin, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user_admin!, only: [:new, :create, :index], raise: false
  layout 'system_admins'

  def index
    @system_admins_user_admins = SystemAdmins::UserAdmin.all
  end

  def show
  end

  def new
    @user_admin = SystemAdmins::UserAdmin.new
  end

  def edit
    @system_admins_user_admin = SystemAdmins::UserAdmin.find(params[:id])
  end

  def create
    @user_admin = SystemAdmins::UserAdmin.new(user_admin_params)

    respond_to do |format|
      if @user_admin.save
        format.html { redirect_to @user_admin, notice: "User admin was successfully created." }
        format.json { render :show, status: :created, location: @user_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @system_admins_user_admin.update(user_admin_params)
        format.html { redirect_to system_admins_user_admins_path, notice: "User admin atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @system_admins_user_admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_admin.destroy!

    respond_to do |format|
      format.html { redirect_to user_admins_path, status: :see_other, notice: "User admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
    def set_user_admin
      @system_admins_user_admin = SystemAdmins::UserAdmin.find(params[:id])
    end

    def user_admin_params
      params.require(:system_admins_user_admin).permit(
        :full_name,
        :email,
        :phone,
        :admin,
        :password,
        :password_confirmation
      )
    end
end
