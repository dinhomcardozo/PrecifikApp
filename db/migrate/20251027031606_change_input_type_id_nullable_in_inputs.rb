class ChangeInputTypeIdNullableInInputs < ActiveRecord::Migration[8.0]
  def change
    change_column_null :inputs, :input_type_id, true
  end
end
