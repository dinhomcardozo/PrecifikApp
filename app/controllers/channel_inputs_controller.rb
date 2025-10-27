class ChannelInputsController < Clients::AuthenticatedController
  before_action :set_channel_input, only: [:update]

  def update
    if @channel_input.update(channel_input_params)
      respond_to do |format|
        format.html { redirect_to @channel_input.input, notice: "Preço atualizado com sucesso." }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_channel_input
    @channel_input = ChannelInput.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @channel_input.client_id == Current.user_client.client_id
  end

  def channel_input_params
    params.require(:channel_input).permit(:corrected_final_price)
  end
end