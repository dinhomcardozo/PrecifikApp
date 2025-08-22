class ChannelsController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user!
  
  before_action :set_channel, only: %i[ show edit update destroy ]

  # GET /channels or /channels.json
  def index
    @channels = Channel.all
  end

  # GET /channels/1 or /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels or /channels.json
  def create
    @channel = Channel.new(channel_params)
    if @channel.save
      redirect_to channels_path, notice: "Canal criado com sucesso"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @channel.update(channel_params)
      redirect_to channels_path, notice: "Canal atualizado com sucesso"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /channels/1 or /channels/1.json
  def destroy
    @channel.destroy
    redirect_to channels_path, notice: "Canal excluído"
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_channel
    @channel = Channel.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def channel_params
    params.require(:channel)
          .permit(:description, :channel_cost, :channel_type)
  end
end
