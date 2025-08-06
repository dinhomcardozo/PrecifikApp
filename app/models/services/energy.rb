module Services
    class Energy < ApplicationRecord
        self.table_name = 'energies'
        validates :consume_per_hour,
              numericality: { other_than: 0,
                              message: "deve ser diferente de zero" }
    end
end