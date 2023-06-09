class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true
  belongs_to :merchants
  has_many :invoices
end