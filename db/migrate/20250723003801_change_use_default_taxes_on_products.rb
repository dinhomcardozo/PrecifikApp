class ChangeUseDefaultTaxesOnProducts < ActiveRecord::Migration[7.0]
  def up
    # se você já tiver uma coluna string, primeiro converte valor para boolean
    add_column :products, :use_default_taxes_bool, :boolean, default: true, null: false

    # popula a nova coluna a partir da antiga string (supondo 'default' = true)
    Product.reset_column_information
    Product.find_each do |p|
      p.update_column(
        :use_default_taxes_bool,
        p.use_default_taxes == "default" # ajusta conforme valor que você gravava
      )
    end

    remove_column :products, :use_default_taxes, :string
    rename_column :products, :use_default_taxes_bool, :use_default_taxes
  end

  def down
    add_column :products, :use_default_taxes_old, :string, default: "default", null: false

    Product.reset_column_information
    Product.find_each do |p|
      p.update_column(
        :use_default_taxes_old,
        p.use_default_taxes? ? "default" : "custom"
      )
    end

    remove_column :products, :use_default_taxes, :boolean
    rename_column :products, :use_default_taxes_old, :use_default_taxes
  end
end