class BackfillRequireUnitsInSubproductCompositions < ActiveRecord::Migration[8.0]
  def up
    SubproductComposition.find_each do |comp|
      if comp.input&.weight.to_f > 0
        comp.update_columns(require_units: (comp.quantity_for_a_unit.to_f / comp.input.weight.to_f).round(2))
      end
    end
  end

  def down
  end
end
