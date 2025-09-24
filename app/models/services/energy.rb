module Services
    class Energy < ApplicationRecord
        self.table_name = "energies"

    validates :client_id, presence: true

    belongs_to :client, class_name: "SystemAdmins::Client"

    validates :consume_per_hour,
              numericality: { other_than: 0,
                              message: "deve ser diferente de zero" }

    scope :for_client, ->(client_id) { where(client_id: client_id) }    


  end
end