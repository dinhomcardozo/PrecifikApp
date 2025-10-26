class PriceList < ApplicationRecord
  belongs_to :client, class_name: "SystemAdmins::Client"

  has_many :price_lists_product_portions
  has_many :product_portions, through: :price_lists_product_portions

  has_many :channels_price_lists
  has_many :channels, through: :channels_price_lists

  has_many :price_list_rules, dependent: :destroy
  accepts_nested_attributes_for :price_list_rules, allow_destroy: true

  validate :non_overlapping_rules
  validate :unique_product_portion_channel_combination
  validates :product_portions, presence: { message: "Selecione pelo menos uma porção de produto" }
  validates :channels, presence: { message: "Selecione pelo menos um canal de venda" }

  private

  def unique_product_portion_channel_combination
    product_portions.each do |portion|
      channels.each do |channel|
        existing = PriceList
          .joins(:product_portions, :channels)
          .where(client_id: client_id)
          .where(product_portions: { id: portion.id })
          .where(channels: { id: channel.id })
          .where.not(id: id)
          .exists?

        if existing
          errors.add(:base, "Já há uma lista de preço com a combinação Porção ##{portion.id} + Canal ##{channel.id}. Volte e edite a lista anterior ou escolha outra combinação.")
        end
      end
    end
  end

  def non_overlapping_rules
    # pega apenas regras válidas (não destruídas e com valores preenchidos)
    rules = price_list_rules.reject(&:marked_for_destruction?).select do |r|
      r.initial_quantity.present? && r.final_quantity.present?
    end

    # ordena por quantidade inicial
    rules.sort_by!(&:initial_quantity)

    # percorre pares consecutivos
    rules.each_cons(2) do |a, b|
      if a.final_quantity >= b.initial_quantity
        errors.add(:base, "Intervalos não podem se sobrepor: #{a.initial_quantity}-#{a.final_quantity} e #{b.initial_quantity}-#{b.final_quantity}")
      end
    end
  end
end
