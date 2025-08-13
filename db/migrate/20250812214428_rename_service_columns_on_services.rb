class RenameServiceColumnsOnServices < ActiveRecord::Migration[8.0]
  def change   
    rename_column :services, :tax_percent,          :tax
    rename_column :services, :profit_margin_percent, :profit_margin
  end
end
