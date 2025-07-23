class AddTaxProfileAndCustomFlagToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products,
                  :tax_profile,
                  foreign_key: true,
                  null: true        # <— permitir null por enquanto
    add_column :products,
               :use_custom_taxes,
               :boolean,
               default: false,
               null: false
  end
end
