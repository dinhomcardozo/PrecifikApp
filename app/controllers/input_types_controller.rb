class InputTypesController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  
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

    if @input_type.save
      redirect_to input_types_path, notice: "Tipo de insumo criado com sucesso."
    else
      render :new
    end
  end

  def update
    @input_type = InputType.find(params[:id])

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
end