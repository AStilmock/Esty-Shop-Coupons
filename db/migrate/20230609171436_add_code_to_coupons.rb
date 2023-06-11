class AddCodeToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :code, :string
    add_column :coupons, :amount, :decimal
    add_column :coupons, :disc_type, :integer
  end
end
