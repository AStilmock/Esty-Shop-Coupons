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

  def discount_amount
    if disc_type = 1
      amount / 100
    else
      amount
    end
  end
end
