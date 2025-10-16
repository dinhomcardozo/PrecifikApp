class BackfillClientIdInServiceProducts < ActiveRecord::Migration[8.0]
  def up
    Services::ServiceProduct.reset_column_information
    Services::ServiceProduct.find_each do |sp|
      sp.update_column(:client_id, sp.service.client_id) if sp.service.present?
    end
  end
end
