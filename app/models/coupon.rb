class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true
  validates :code, presence: true
  validates :amount, presence: true, numericality: true
  validates :disc_type, presence: true

  belongs_to :merchant
  has_many :invoices
  enum status: [:deactivated, :activated]
  enum disc_type: [:dollar, :percent]

  def use_count
    invoices.joins(:transactions)
    .where(transactions: { result: 1 }).count
  end
end
