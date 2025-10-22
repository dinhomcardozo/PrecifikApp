class Tax < ApplicationRecord
    default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
    has_many :products
    has_many :product_portions, dependent: :nullify

    after_commit :update_related_product_portions, on: %i[create update destroy]

    private

    def update_related_product_portions
    product_portions.find_each do |portion|
        portion.update!(
        cost: portion.cost,
        final_cost: portion.final_cost,
        final_price: portion.final_price
        )
    end
    end
end