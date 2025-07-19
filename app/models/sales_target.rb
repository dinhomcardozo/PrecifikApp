class SalesTarget < ApplicationRecord
  belongs_to :package
  belongs_to :channel

  validates :monthly_target, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate  :end_after_start

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "deve ser posterior à data de início") if end_date < start_date
  end
end
