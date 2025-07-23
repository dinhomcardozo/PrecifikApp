class Product < ApplicationRecord
  belongs_to :brand, optional: false
  before_save :apply_non_recoverable_taxes

  has_many :product_subproducts, inverse_of: :product, dependent: :destroy
  has_many :subproducts, through: :product_subproducts
  has_many :product_tax_overrides, dependent: :destroy
  accepts_nested_attributes_for :product_tax_overrides, allow_destroy: true

  validates :description, presence: true
  validates :brand_id,    presence: true

  # Permite que o formulário aninhado crie/edite product_subproducts

  accepts_nested_attributes_for :product_subproducts,
                                allow_destroy: true,
                                reject_if:     proc { |attrs|
                                  attrs['subproduct_id'].blank?
                                }

  # torna weight “somente em memória” - peso que o usuário digita
  attr_accessor :weight

  # 1 - Product Configuration

  # (Vazio) Only margem varejo x margem atacado %

  # 2 - Aggregate_costs

  def total_aggregate_costs
    [
      financial_cost.to_f,
      (sales_channel_cost.to_f if respond_to?(:sales_channel_cost)),
      (commission_cost.to_f if respond_to?(:commission_cost)),
      (freight_cost.to_f if respond_to?(:freight_cost)),
      (storage_cost.to_f if respond_to?(:storage_cost))
    ].compact.sum
  end

  # 3 - Product Composition

  def total_weight
    product_subproducts.sum { |ps| ps.quantity.to_f }
  end

  # 4 - Pricing

  # Preço sugerido varejo = total_cost * (1 + profit_margin_retail/100)
  def suggested_retail_price
    total_cost * (1 + profit_margin_retail.to_f / 100)
  end

  # Preço sugerido atacado = total_cost * (1 + profit_margin_wholesale.to_f / 100)
  def suggested_wholesale_price
    total_cost * (1 + profit_margin_wholesale.to_f / 100)
  end

  # Lucro bruto é a diferença entre o preço sugerido e o custo
  def gross_profit_retail
    suggested_retail_price - total_cost
  end

  def gross_profit_wholesale
    suggested_wholesale_price - total_cost
  end

  # Lucro líquido: subtrai dos lucros brutos os custos agregados
  def net_profit_retail
    gross_profit_retail - aggregated_costs
  end

  def net_profit_wholesale
    gross_profit_wholesale - aggregated_costs
  end

  # Método auxiliar para somar os custos agregados (que estão na tabela products)
  def total_cost
    product_subproducts.sum(:cost)
  end
  
  def aggregated_costs
    pct = (financial_cost.to_f +
           sales_channel_cost.to_f +
           commission_cost.to_f) / 100.0

    total_cost * pct +
      freight_cost.to_f +
      storage_cost.to_f
  end

  def apply_non_recoverable_taxes
    return if use_default_taxes?   # agora existe!

    overrides     = product_tax_overrides.non_recoverable
    total_percent = overrides.sum(&:value) / 100.0
    self.cost_with_taxes = total_cost * (1 + total_percent)
  end
end