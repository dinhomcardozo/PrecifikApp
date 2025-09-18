class Clients::MessagesController < ApplicationController
  before_action :authenticate_user_client!

  def index
    @messages = SystemAdmins::Message.all.select do |msg|
      msg.active_now? && msg.client_ids_array.include?(Current.user_client.client_id)
    end
  end

  def show
    @message = SystemAdmins::Message.find(params[:id])

    unless @message.active_now? && @message.client_ids_array.include?(Current.user_client.client_id)
      redirect_to clients_messages_path, alert: "Mensagem não disponível."
    end
  end
end