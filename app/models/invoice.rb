class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    self.invoice_items.sum("unit_price * quantity")
  end

  def total_rev_discount
    require 'pry'; binding.pry
    if coupon.disc_type == "percent"
      total_revenue * (1-coupon.discount_amount)
    else
      total_revenue - coupon.amount
    end
  end
end
