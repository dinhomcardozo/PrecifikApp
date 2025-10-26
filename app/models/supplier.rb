class Supplier < ApplicationRecord
  default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
  has_many :inputs
  has_many :packages
  belongs_to :client, class_name: "SystemAdmins::Client"

  validates :name, presence: true
  validates :cnpj,
            presence: { message: "deve ser preenchido (somente números)" },
            uniqueness: {
              message: ->(object, data) do
                "O CNPJ #{object.cnpj} já existe. Use outro ou verifique o cadastro anterior."
              end
            },
            format: {
              with: /\A\d{14}\z/,
              message: "deve conter exatamente 14 números (somente dígitos, sem pontos ou traços)"
            }
end