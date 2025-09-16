class InputTypesController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  before_action :set_client_id, only: %i[create update]
  
  def index
    @input_types = InputType.all
  end

  def show
    @input_type = InputType.find(params[:id])
  end

  def new
    @input_type = InputType.new
  end

  def edit
    @input_type = InputType.find(params[:id])
  end

  def create
    @input_type = InputType.new(input_type_params)
    @input_type.client_id = Current.user_client.client_id

    if @input_type.save
      redirect_to input_types_path, notice: "Tipo de insumo criado com sucesso."
    else
      render :new
    end
  end

  def update
    @input_type = InputType.find(params[:id])
    @input_type.client_id = Current.user_client.client_id

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

  def set_client_id
    if action_name == "create"
      @input_type = InputType.new(input_type_params)
    else
      @input_type = InputType.find(params[:id])
      @input_type.assign_attributes(input_type_params)
    end
    @input_type.client_id = Current.user_client.client_id
  end
end