# app/controllers/system_admins/messages_controller.rb
class SystemAdmins::MessagesController < ApplicationController
  # before_action :authenticate_user_admin!
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = SystemAdmins::Message.order(created_at: :desc)
  end

  def new
    @message = SystemAdmins::Message.new
  end

  def show
  end

  def create
    @message = SystemAdmins::Message.new(message_params)
   # @message.created_by = Current.user_client || Current.user_admin

    if @message.save
      redirect_to system_admins_messages_path, notice: "Mensagem criada com sucesso."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @message.update(message_params)
      redirect_to system_admins_messages_path, notice: "Mensagem atualizada."
    else
      render :edit
    end
  end

  def destroy
    @message.destroy
    redirect_to system_admins_messages_path, notice: "Mensagem excluída."
  end

  private

  def set_message
    @message = SystemAdmins::Message.find(params[:id])
  end

  def message_params
    params.require(:system_admins_message).permit(
      :title, :body, :client_ids_text, :start_date, :end_date, :start_hour, :end_hour, plans: []
    )
  end

  def authorize_admin!
    unless Current.user_client.present? || Current.user_admin.present?
        redirect_to root_path, alert: "Acesso negado."
    end
  end
end