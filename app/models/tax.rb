class Tax < ApplicationRecord
    default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
    has_many :products

    after_save :update_related_product_portions

    private

    def update_related_product_portions
        product_portions.find_each(&:save!)
    end
end