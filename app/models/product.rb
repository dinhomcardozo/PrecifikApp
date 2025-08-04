class Product < ApplicationRecord
  belongs_to :brand, optional: false
  belongs_to :tax,   optional: true
  has_one :sales_target,
          inverse_of: :product,
          dependent: :destroy

  has_one_attached :image

  delegate :distributed_fixed_cost,
           to: :sales_target,
           allow_nil: true

  delegate :monthly_target,
           to: :sales_target,
           prefix: false,
           allow_nil: true

  before_validation :calculate_pricing, if: :pricing_attributes_changed?

  after_save :store_total_cost, if: :product_subproducts_changed?
  after_save :store_total_cost_with_fixed_costs

  has_many   :product_subproducts, inverse_of: :product, dependent: :destroy
  has_many   :subproducts, through: :product_subproducts

  # Permite que o formulário aninhado crie/edite product_subproducts

  accepts_nested_attributes_for :product_subproducts,
                                allow_destroy: true,
                                reject_if:     proc { |attrs|
                                  attrs['subproduct_id'].blank?
                                }

  # torna weight “somente em memória” - peso que o usuário digita
  attr_accessor :weight

  def total_cost
    product_subproducts.sum(:cost)
  end

  def store_total_cost
    update_column(:total_cost, product_subproducts.sum(:cost))
  end

# 1 – Composição
  def total_weight
    product_subproducts.sum { |ps| ps.quantity.to_f }
  end

  # 3 – TRIBUTOS

      # Custo total com tributos
  def total_cost_with_taxes
    (total_cost + total_taxes_amount).round(2)
  end

      # Soma de todos os % de tributos sobre total_cost
  def total_taxes_amount
    return 0 unless tax

    %i[icms ipi pis_cofins difal iss cbs ibs].sum do |field|
      (tax.send(field).to_f / 100.0) * total_cost
    end.round(2)
  end


  # CUSTOS FIXOS - soma total_cost + distributed_fixed_cost (sem tributos)
  def store_total_cost_with_fixed_costs
    update_column(
      :total_cost_with_fixed_costs,
      total_cost + sales_target&.distributed_fixed_cost.to_f
    )
  end

   # 4. Preços sugeridos
  def suggested_price_retail
    (total_cost_with_taxes * (1 + profit_margin_retail.to_f / 100.0)).round(2)
  end

  def suggested_price_wholesale
    (total_cost_with_taxes * (1 + profit_margin_wholesale.to_f / 100.0)).round(2)
  end

  # lucro líquido | varejo e atacado
  def net_profit_retail
    (suggested_price_retail - total_cost_with_taxes).round(2)
  end

  def net_profit_wholesale
    (suggested_price_wholesale - total_cost_with_taxes).round(2)
  end

  private

  def pricing_attributes_changed?
    total_cost_changed? ||
      tax_id_changed? ||
      profit_margin_retail_changed? ||
      profit_margin_wholesale_changed? ||
      product_subproducts.any?(&:changed?)
  end

  def calculate_pricing
    return unless tax && total_cost.present?

    # soma de alíquotas em percentual
    total_factor = 1 + %i[icms ipi pis_cofins difal iss cbs ibs]
                       .map { |attr| tax.send(attr).to_f / 100.0 }
                       .sum

    self.total_cost_with_taxes    = (total_cost * total_factor).round(2)
    self.suggested_price_retail    = (total_cost_with_taxes * 
                                      (1 + profit_margin_retail.to_f / 100.0)).round(2)
    self.suggested_price_wholesale = (total_cost_with_taxes * 
                                      (1 + profit_margin_wholesale.to_f / 100.0)).round(2)
  end

  def compute_pricing
    self.suggested_price_retail    = suggested_price_retail
    self.suggested_price_wholesale = suggested_price_wholesale
  end

  def product_subproducts_changed?
    product_subproducts.any?(&:saved_change_to_cost?)
  end
end