class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :status
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
