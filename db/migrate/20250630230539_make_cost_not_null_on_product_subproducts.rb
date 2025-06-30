class MakeCostNotNullOnProductSubproducts < ActiveRecord::Migration[8.0]
  def up
    # Primeiro substitui eventuais NULLs por 0
    ProductSubproduct.where(cost: nil).update_all(cost: 0.0)
    # Depois altera a coluna para não aceitar NULL e definir default zero
    change_column_default :product_subproducts, :cost, 0.0
    change_column_null    :product_subproducts, :cost, false
  end

  def down
    change_column_null    :product_subproducts, :cost, true
    change_column_default :product_subproducts, :cost, nil
  end
end
