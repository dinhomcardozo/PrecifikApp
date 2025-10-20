class SystemAdmins::Message < ApplicationRecord
  self.table_name = "messages"
  
  validates :title, :body, presence: true

  has_many :message_reads, dependent: :destroy

  has_and_belongs_to_many :plans,
                          class_name: "SystemAdmins::Plan",
                          join_table: "messages_plans"

  # Converte o texto de IDs em array de inteiros
  def client_ids_array
    (client_ids_text || "")
      .split(",")
      .map(&:strip)
      .map(&:to_i)
      .reject(&:zero?)
  end

  # Verifica se a mensagem está ativa no momento
  def active_now?
    today = Date.current
    now_time = Time.current.strftime("%H:%M")

    in_date_range = (start_date.nil? || today >= start_date) &&
                    (end_date.nil? || today <= end_date)

    in_time_range = (start_hour.nil? || now_time >= start_hour.strftime("%H:%M")) &&
                    (end_hour.nil? || now_time <= end_hour.strftime("%H:%M"))

    in_date_range && in_time_range
  end

  def read_by?(client)
    message_reads.where(client_id: client.id).where.not(read_at: nil).exists?
  end
end