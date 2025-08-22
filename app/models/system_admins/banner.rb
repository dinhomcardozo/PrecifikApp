module SystemAdmins
  class Banner < ApplicationRecord
    self.table_name = 'banners'
    validates :image, :link, :start_date, :end_date, presence: true


    scope :active, -> {
      where('start_date <= :today AND end_date >= :today',
            today: Date.current)
    }
  end
end