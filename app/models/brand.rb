class Brand < ApplicationRecord
    default_scope { where(client_id: Current.user_client.client_id) if Current.user_client }
    belongs_to :client, class_name: "SystemAdmins::Client", foreign_key: "client_id"
    
    has_many :inputs
    has_many :subproducts
    has_many :products

    validates :name, presence: true, uniqueness: { scope: :client_id }

    scope :main_brands, -> { where(main_brand: true) }

    def in_use?
      inputs.exists? || subproducts.exists? || products.exists?
    end
end