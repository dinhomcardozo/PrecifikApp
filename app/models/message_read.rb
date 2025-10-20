class MessageRead < ApplicationRecord
  belongs_to :message, class_name: "SystemAdmins::Message"
  belongs_to :client, class_name: "SystemAdmins::Client"

  def read?
    read_at.present?
  end
end
