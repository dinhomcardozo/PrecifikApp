module SystemAdmins
  class Banner < ApplicationRecord
    self.table_name = 'banners'

    belongs_to :plan, class_name: "SystemAdmins::Plan", optional: true
    has_many :banner_clients, dependent: :destroy
    has_many :clients, through: :banner_clients

    validates :image, :link, :start_date, :end_date, presence: true
    validate :end_date_after_start_date

    scope :active, -> {
      where('start_date <= :today AND end_date >= :today',
            today: Date.current)
    }

    scope :for_client, ->(client) {
      active
        .where("plan_id IS NULL OR plan_id = ?", client.plan_id)
        .joins("LEFT JOIN banner_clients ON banner_clients.banner_id = banners.id")
        .where("banner_clients.client_id IS NULL OR banner_clients.client_id = ?", client.id)
        .distinct
    }

    attr_accessor :client_ids_csv

    after_initialize do
      self.client_ids_csv ||= clients.pluck(:id).join(",") if persisted?
    end

    after_save :assign_clients_from_csv

    private

    def end_date_after_start_date
      return if end_date.blank? || start_date.blank?
      errors.add(:end_date, "deve ser depois da data inicial") if end_date < start_date
    end

    def assign_clients_from_csv
      return if client_ids_csv.blank?

      ids = client_ids_csv.split(",").map(&:strip).reject(&:blank?).map(&:to_i)
      self.clients = SystemAdmins::Client.where(id: ids)
    end
  end
end