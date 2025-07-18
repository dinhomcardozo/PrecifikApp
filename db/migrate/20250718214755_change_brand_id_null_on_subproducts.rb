class ChangeBrandIdNullOnSubproducts < ActiveRecord::Migration[8.0]
  def up
    change_column_null :subproducts, :brand_id, true
  end

  def down
    # se quiser voltar a obrigar, garanta que exista uma marca default (id = 1 ou similar)
    change_column_null :subproducts, :brand_id, false, 1
  end
end
