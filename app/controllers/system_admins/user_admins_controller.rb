class SystemAdmins::UserAdminsController < SystemAdmins::BaseController
  before_action :authenticate_user_admin! # garante login
  before_action :authorize_super_admin!, only: %i[new create]
  before_action :set_system_admins_user_admin, only: %i[show edit update destroy]
  skip_before_action :ensure_user_admin_is_admin!, only: [:edit, :update]
  layout :resolve_layout

  def index
    @system_admins_user_admins = SystemAdmins::UserAdmin.all
  end

  def show
  end

  def new
    @system_admins_user_admin = SystemAdmins::UserAdmin.new
  end

  def edit
  end

  def create
    @system_admins_user_admin = SystemAdmins::UserAdmin.new(user_admin_params)

    respond_to do |format|
      if @system_admins_user_admin.save
        format.html { redirect_to system_admins_user_admin_path(@system_admins_user_admin), notice: "User admin criado com sucesso." }
        format.json { render :show, status: :created, location: @system_admins_user_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_admins_user_admin.errors, status: :unprocessable_entity }
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
    @system_admins_user_admin.destroy!
    respond_to do |format|
      format.html { redirect_to system_admins_user_admins_path, status: :see_other, notice: "User admin removido com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  def set_system_admins_user_admin
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

  def authorize_super_admin!
    unless current_user_admin&.admin?
      redirect_to system_admins_user_admins_path, alert: "Você não tem permissão para criar novos administradores."
    end
  end
end