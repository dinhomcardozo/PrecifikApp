class InputType < ApplicationRecord
  scope :for_client, ->(client_id) { where(client_id: client_id) }
  before_validation :set_client_id
  has_many :inputs

  validates :name, presence: true,
            uniqueness: { scope: :client_id, message: "já existe para este cliente" }

  def set_client_id
    self.client_id ||= Current.user_client&.client_id
  end
end