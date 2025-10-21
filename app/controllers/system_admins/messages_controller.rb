module SystemAdmins
  class MessagesController < SystemAdmins::BaseController
    before_action :authenticate_user_admin!
    before_action :set_message, only: [:show, :edit, :update, :destroy]
    before_action :set_plans, only: [:new, :edit, :create, :update]

    layout :resolve_layout

    def index
      @messages = SystemAdmins::Message.order(created_at: :desc)
      @plans = SystemAdmins::Plan.all
    end

    def new
      @message = SystemAdmins::Message.new
      @plans = SystemAdmins::Plan.all
    end

    def show
      @plans = SystemAdmins::Plan.all
    end

    def create
      @message = SystemAdmins::Message.new(message_params)
      if @message.save
        redirect_to system_admins_messages_path, notice: "Mensagem criada com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @plans = SystemAdmins::Plan.all
    end

    def update
      if @message.update(message_params)
        redirect_to system_admins_messages_path, notice: "Mensagem atualizada."
      else
        @plans = SystemAdmins::Plan.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @message.destroy
      redirect_to system_admins_messages_path, notice: "Mensagem excluída."
    end

    private

    def resolve_layout
      if devise_controller? && resource_name == :user_admin && action_name == "new"
        "system_admins_login"
      else
        "system_admins"
      end
    end

    def set_message
      @message = SystemAdmins::Message.find(params[:id])
    end

    def set_plans
      @plans = SystemAdmins::Plan.all
    end

    def message_params
      params.require(:system_admins_message).permit(
        :title, :body, :client_ids_text, :start_date, :end_date, :start_hour, :end_hour, :image, plan_ids: []
      )
    end
  end
end