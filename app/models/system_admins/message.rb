class SystemAdmins::Message < ApplicationRecord
  self.table_name = "messages"

  has_many :message_clients, dependent: :destroy
  has_many :clients, through: :message_clients

  has_one_attached :image
  
  validates :title, :body, presence: true

  has_many :message_reads, dependent: :destroy

  has_and_belongs_to_many :plans,
                          class_name: "SystemAdmins::Plan",
                          join_table: "messages_plans"

  before_save :sync_clients_from_text

  # Converte o texto de IDs em array de inteiros
  def client_ids_array
    return [] if client_ids_text.blank?
    client_ids_text.gsub(/[

  \[\]

  ]/, "") # remove colchetes
                  .split(",")
                  .map(&:strip)
                  .map(&:to_i)
                  .reject(&:zero?)
  end

  def active_now?
    now = Time.current
    today = Date.current

    in_date_range = (start_date.nil? || today >= start_date) &&
                    (end_date.nil? || today <= end_date)

    in_time_range = true
    in_time_range &&= now.seconds_since_midnight >= start_hour.seconds_since_midnight if start_hour.present?
    in_time_range &&= now.seconds_since_midnight <= end_hour.seconds_since_midnight if end_hour.present?

    in_date_range && in_time_range
  end

  def read_by?(client)
    message_reads.where(client_id: client.id).where.not(read_at: nil).exists?
  end

  private

  def sync_clients_from_text
    self.clients = SystemAdmins::Client.where(id: client_ids_array)
  end
end