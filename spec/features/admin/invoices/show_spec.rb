require "rails_helper"

RSpec.describe "Admin Invoices" do
  describe "Admin Invoices Index Page" do
    before :each do
      @m1 = Merchant.create!(name: "Merchant 1")

      @coupon1 = Coupon.create!(name: "10% OFF Discount", status: 1, code: "10-OFF", amount: 10, disc_type: 1, merchant_id: @m1.id)

      @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
      @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: @coupon1.id)
      @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09", coupon_id: @coupon1.id)

      @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
      @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

      visit admin_invoice_path(@i1)
    end

    it "should display the id, status and created_at" do
      expect(page).to have_content("Invoice ##{@i1.id}")
      expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

      expect(page).to_not have_content("Invoice ##{@i2.id}")
    end

    it "should display the customers name and shipping address" do
      expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
      expect(page).to have_content(@c1.address)
      expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

      expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
    end

    it "should display all the items on the invoice" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_1.unit_price}")
      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content("$#{@ii_3.unit_price}")
      expect(page).to_not have_content(@ii_3.status)
    end

    it "should display the total revenue the invoice will generate" do
      expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

      expect(page).to_not have_content(@i2.total_revenue)
    end

    it "should have status as a select field that updates the invoices status" do
      within("#status-update-#{@i1.id}") do
        select("cancelled", :from => "invoice[status]")
        expect(page).to have_button("Update Invoice")
        click_button "Update Invoice"

        expect(current_path).to eq(admin_invoice_path(@i1))
        expect(@i1.status).to eq("completed")
      end
    end
  end

  describe "Admin Invoices Show Page" do
    before :each do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @merchant2 = Merchant.create!(name: "Jewelry")

      @coupon1 = Coupon.create!(name: "10% OFF Discount", status: 1, code: "10-OFF", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon2 = Coupon.create!(name: "10% OFF Discount HOLIDAY", status: 1, code: "10-OFF-HOLIDAY", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon3 = Coupon.create!(name: "10% OFF Discount LOYALTY", status: 1, code: "10-OFF-LOYALTY", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon4 = Coupon.create!(name: "10% OFF Discount WEEKEND", status: 1, code: "10-OFF-WEEKEND", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon5 = Coupon.create!(name: "10% OFF Discount FRIENDS", status: 1, code: "10-OFF-FRIENDS", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon6 = Coupon.create!(name: "10% OFF Discount FAMILY", status: 0, code: "10-OFF-FAMILY", amount: 10, disc_type: 1, merchant_id: @merchant1.id)
      @coupon7 = Coupon.create!(name: "BOGO $10 OFF", status: 0, code: "BOGO$10", amount: 10, disc_type: 0, merchant_id: @merchant1.id)

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
      @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
      @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
      @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
      @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon1.id)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09", coupon_id: @coupon1.id)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon1.id)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon1.id)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, coupon_id: @coupon1.id)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2, coupon_id: @coupon1.id)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2, coupon_id: @coupon1.id)

      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1, coupon_id: @coupon1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 12, unit_price: 6, status: 1)

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    end

    it "admin invoice show page revenue" do
      visit admin_invoice_path(@invoice_1)
      within "#sub-total-revenue" do
        expect(page).to have_content("Subtotal Invoice Revenue: $#{@invoice_1.total_revenue}")
        expect(@invoice_1.total_revenue).to equal(162.0)
      end

      within "#total-revenue" do
        expect(page).to have_content("Total Invoice Revenue With Coupon: $#{@invoice_1.total_rev_discount}")
        expect(@invoice_1.total_rev_discount).to equal(145.8)
        expect(page).to have_content "Used Coupon Name: #{@coupon1.name}"
        expect(page).to have_content "Used Coupone Code: #{@coupon1.code}"
      end
    end
  end
end
