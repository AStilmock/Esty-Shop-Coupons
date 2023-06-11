require "rails_helper"

RSpec.describe "Coupon New" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
    

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @coupon1 = Coupon.create!(name: "10% OFF Discount", status: 1, code: "10-OFF", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create!(name: "10% OFF Discount HOLIDAY", status: 1, code: "10-OFF-HOLIDAY", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create!(name: "10% OFF Discount LOYALTY", status: 1, code: "10-OFF-LOYALTY", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create!(name: "10% OFF Discount WEEKEND", status: 1, code: "10-OFF-WEEKEND", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon5 = Coupon.create!(name: "10% OFF Discount FRIENDS", status: 1, code: "10-OFF-FRIENDS", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon6 = Coupon.create!(name: "10% OFF Discount FAMILY", status: 0, code: "10-OFF-FAMILY", amount: 0.1, disc_type: 1, merchant_id: @merchant1.id)
    @coupon7 = Coupon.create!(name: "BOGO $10 OFF", status: 0, code: "BOGO$10", amount: 10.0, disc_type: 0, merchant_id: @merchant1.id)
  end
  describe "Merchant Coupon New Page" do
    it "has form to create new coupon" do
      # 2. Merchant Coupon Create 

      visit "/merchants/#{@merchant1.id}/coupons/new"
      expect(page).to have_field("Name")
      expect(page).to have_field("Code")
      expect(page).to have_field("Amount")
      expect(page).to have_field("Disc type")

      fill_in "Name", with: "BOGO $10 OFF"
      fill_in "Code", with: "BOGO$10"
      fill_in "Amount", with: "not_a_number"
      fill_in "Disc type", with: "dollar"
      click_button "Submit"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
      expect(page).to have_content("ERROR - VALID DATA MUST BE ENTERED FOR COUPON CREATION")

      fill_in "Name", with: "BOGO $10 OFF"
      fill_in "Code", with: "BOGO$10"
      fill_in "Amount", with: 10.0
      fill_in "Disc type", with: "dollar"
      fill_in "Status", with: "deactivated"
      click_button "Submit"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons")

      within "#coupons" do
        expect(page).to have_content("Coupon Name: #{@coupon7.name}")
        expect(page).to have_content("Coupon Code: #{@coupon7.code}")
      end

      expect(page).to have_content("Deactivated Coupon Successfully Created")
    end
  end
end