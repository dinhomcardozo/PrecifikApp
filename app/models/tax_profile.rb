class TaxProfile < ApplicationRecord
  has_many :items, class_name: "TaxProfileItem", dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  validates :description, presence: true
  validates :default, inclusion: { in: [true, false] }

  # se marcar um como default, desmarca os outros
  after_save :ensure_single_default, if: -> { saved_change_to_default? && default? }

  scope :active,   -> { where(active: true) }
  scope :defaults, -> { where(default: true) }

  def self.primary
    defaults.first || active.first
  end

  private

  def ensure_single_default
    TaxProfile.where.not(id: id).update_all(default: false)
  end
end