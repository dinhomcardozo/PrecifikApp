module SystemAdmins
  class Client < ApplicationRecord
    self.table_name = 'clients'

    has_many :user_clients, class_name: 'SystemAdmins::UserClient', foreign_key: :client_id
    belongs_to :plan, class_name: 'SystemAdmins::Plan', foreign_key: :plan_id
    validates :plan_id, presence: true

    validates :cpf,
              presence: true,
              format: { with: /\A\d{11}\z/, message: "deve conter 11 números" }
    
    validates :cnpj, :razao_social, :company_name,
              :first_name, :last_name, :phone,
              :address, :number_address,
              presence: true

    validates :cnpj,
            presence: true,
            uniqueness: { case_sensitive: false, message: "já existe na base de dados. Crie outra conta ou entre em contato com nossa equipe para alteração." }

    def valid_until
      if free?
        Float::INFINITY
      elsif mensal?
        last_payment.to_datetime + 30.days
      elsif anual?
        last_payment.to_datetime + 365.days
      elsif trial?
        created_at + 30.days
      end
    end

    def subscription_active?
      return true if free?

      if mensal?
        last_payment.present? && last_payment >= 30.days.ago
      elsif anual?
        last_payment.present? && last_payment >= 365.days.ago
      elsif trial?
        created_at >= 30.days.ago
      else
        false
      end
    end

    def free?
      plan_id == 1 
    end

    def mensal?
      plan_id == 2
    end

    def anual?
      plan_id == 3
    end

    def trial?
      plan_id == 4
    end

  end
end