require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :status }
    it { should validate_presence_of :code }
  end
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end
end