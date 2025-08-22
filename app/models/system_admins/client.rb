module SystemAdmins
  class Client < ApplicationRecord
    self.table_name = 'clients'

    enum :plan_id, {
      free:   1,
      mensal: 2,
      anual:  3,
      trial:  4
    }

    belongs_to :plan

    belongs_to :user_client,
               class_name: 'SystemAdmins::UserClient',
               inverse_of: :client

    has_many :user_clients,
             class_name: 'SystemAdmins::UserClient',
             foreign_key: 'client_id',
             inverse_of: :client,
             dependent: :destroy

    validates :cnpj, :razao_social, :company_name,
              :first_name, :last_name, :phone,
              :address, :number_address,
              presence: true

    def valid_until
      case plan_id.to_sym
      when :free
        Float::INFINITY
      when :mensal
        last_payment.to_datetime + 30.days
      when :anual
        last_payment.to_datetime + 365.days
      when :trial
        created_at + 30.days
      end
    end

    def subscription_active?
      return true if free?

      case plan_id.to_sym
      when :mensal
        last_payment.present? && last_payment >= 30.days.ago
      when :anual
        last_payment.present? && last_payment >= 365.days.ago
      when :trial
        created_at >= 30.days.ago
      else
        false
      end
    end
  end
end