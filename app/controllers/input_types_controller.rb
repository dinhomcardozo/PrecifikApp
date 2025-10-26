class InputTypesController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"

  def index
    @input_types = InputType.where(client_id: Current.user_client.client_id)
  end

  def show
    @input_type = current_client_input_types.find(params[:id])
  end

  def new
    @input_type = current_client_input_types.new
  end

  def edit
    @input_type = current_client_input_types.find(params[:id])
  end

  def create
    @input_type = current_client_input_types.new(input_type_params)

    if @input_type.save
      redirect_to input_types_path, notice: "Tipo de insumo criado com sucesso."
    else
      render :new
    end
  end

  def update
    @input_type = current_client_input_types.find(params[:id])

    if @input_type.update(input_type_params)
      redirect_to input_types_path, notice: "Tipo de insumo atualizado com sucesso."
    else
      render :edit
    end
  end

  private

  def input_type_params
    params.require(:input_type).permit(:name)
  end

  def current_client_input_types
    InputType.where(client_id: Current.user_client.client_id)
  end
end