class SuppliersController < Clients::AuthenticatedController
  include AuthorizationForClients
  before_action :authenticate_user_client!
  layout "application"
  require "csv"
  
  def index
    @q = params[:q]

    suppliers = Supplier.all

    if @q.present?
      suppliers = suppliers.where("name ILIKE ? OR cnpj ILIKE ?", "%#{@q}%", "%#{@q}%")
    end

    @suppliers = suppliers
              .order("#{sort_column} #{sort_direction}")
              .paginate(page: params[:page], per_page: 10)
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def new
    @supplier = Supplier.new
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def create
    @supplier = Supplier.new(supplier_params)
    @supplier.client_id = current_user_client.client_id

    if @supplier.save
      redirect_to suppliers_path, notice: "Fornecedor criado com sucesso."
    else
      flash.now[:alert] = @supplier.errors.full_messages.join("<br>").html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: "Fornecedor atualizado com sucesso."
    else
      flash.now[:alert] = @supplier.errors.full_messages.join("<br>").html_safe
      render :edit, status: :unprocessable_entity
    end
  end

  def new_upload
  end

  def import
    file = params[:file]
    if file.present?
      errors = []
      imported = 0

      CSV.foreach(file.path, headers: true, encoding: "UTF-8") do |row|
        name  = row["name"]
        cnpj  = row["cnpj"].to_s.strip
        email = row["email"]

        # valida caracteres do CNPJ (somente números)
        if cnpj.match?(/\D/)
          errors << "A linha (#{name}) - CNPJ (#{cnpj}) - Email (#{email}) contém outros caracteres no CNPJ. Verifique e faça a edição para manter os cadastros corretos."
          next
        end

        # ignora duplicados
        if Supplier.exists?(cnpj: cnpj)
          next
        end

        supplier = Supplier.new(
          name: name,
          cnpj: cnpj,
          email: email,
          client: current_user_client.client
        )

        if supplier.save
          imported += 1
        else
          errors << "Erro ao importar (#{name}) - CNPJ (#{cnpj}): #{supplier.errors.full_messages.join(", ")}"
        end
      end

      if errors.any?
        flash[:alert] = errors.join("<br>").html_safe
      end
      flash[:notice] = "#{imported} fornecedores importados com sucesso." if imported > 0

      redirect_to suppliers_path
    else
      redirect_to suppliers_path, alert: "Selecione um arquivo para upload."
    end
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def sortable_columns
    %w[
      suppliers.id
      suppliers.name
      suppliers.cnpj
      suppliers.email
    ]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "suppliers.id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def supplier_params
    params.require(:supplier).permit(:name, :cnpj, :address, :number_address, :state, :city, :phone, :email)
  end
end