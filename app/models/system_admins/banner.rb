class SystemAdmins::Banner < ApplicationRecord
    validates :image, :link, :start_date, :end_date, presence: true

    # Scope que retorna banners cujo hoje está entre start_date e end_date
    scope :active, -> {
      where('start_date <= :today AND end_date >= :today',
            today: Date.current)
    }
end