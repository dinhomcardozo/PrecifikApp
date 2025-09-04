class FixedCostItem < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  belongs_to :sales_target

  belongs_to :sales_target
  after_commit -> { sales_target.recalc_total_fixed_cost! },
               on: [:create, :update, :destroy]

  private

  def refresh_sales_target_total
    sales_target.update_column(
      :total_fixed_cost,
      sales_target.fixed_cost_items.sum(:amount)
    )
  end
end