module SystemAdmins
  class PlansController < SystemAdmins::BaseController
    before_action :set_plan, only: %i[ show edit update destroy ]
    before_action :ensure_super_admin!, only: %i[new create edit update destroy]

    layout :resolve_layout

    def index
      @system_admins_plans = SystemAdmins::Plan.all
    end

    def show
      @system_admins_plan = SystemAdmins::Plan.find(params[:id])
    end

    def new
      @plan = SystemAdmins::Plan.new
    end

    def create
      @plan = SystemAdmins::Plan.new(plan_params)
      if @plan.save
        redirect_to system_admins_plans_path, notice: "Plano criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @plan.update(plan_params)
        redirect_to system_admins_plan_path(@plan), notice: "Plano atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @plan.destroy!
      redirect_to system_admins_plans_path, status: :see_other, notice: "Plano excluído com sucesso."
    end

    private

    def set_plan
      @plan = SystemAdmins::Plan.find(params[:id])
    end

    def plan_params
      params.require(:system_admins_plan).permit(:description, :price, :status)
    end

    def ensure_super_admin!
      unless current_user_admin&.super_admin?
        redirect_to system_admins_plans_path, alert: "Acesso negado. Apenas super administradores podem alterar planos."
      end
    end
  end
end