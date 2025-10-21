class Clients::MessagesController < ApplicationController
  before_action :authenticate_user_client!
  layout 'application'

  before_action :set_message, only: [:show]

  def index
    client_id = current_user_client.client_id

    @messages = current_user_client.client.messages
                  .select { |m| m.active_now? }
                  .sort_by(&:created_at)
                  .reverse
  end

  def show
    unless @message.active_now? && @message.clients.exists?(id: current_user_client.client_id)
      redirect_to messages_path, alert: "Mensagem não disponível." and return
    end

    # Marca como lida
    MessageRead.find_or_create_by!(
      message: @message,
      client_id: current_user_client.client_id
    ).update(read_at: Time.current)
  end

  private

  def set_message
    @message = SystemAdmins::Message.find(params[:id])

    unless @message.clients.exists?(id: current_user_client.client_id)
      redirect_to messages_path, alert: "Você não tem acesso a esta mensagem."
    end
  end
end