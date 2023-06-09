class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :status,
                        :code
  belongs_to :merchant
  has_many :invoices
  enum status: [:enabled, :disabled]
end