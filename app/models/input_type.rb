class InputType < ApplicationRecord
  before_validation :set_client_id
  has_many :inputs

  validates :name, presence: true, uniqueness: true

  def set_client_id
    self.client_id ||= Current.user_client&.client_id
  end
end