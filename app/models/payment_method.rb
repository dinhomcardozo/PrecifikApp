class PaymentMethod < ApplicationRecord
  has_many :payment_method_installments, dependent: :destroy

  enum fee_type: { flat: "flat", percentage: "percentage" }

  def installment_fee_for(count)
    return 0 if code != "credit_card"
    rec = payment_method_installments.find_by(installment_count: count)
    (rec&.percentage_fee || 0) / 100.0
  end
end