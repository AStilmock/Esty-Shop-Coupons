class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayService.upcoming_holidays[0..2]
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @new_coupon = @merchant.coupons.new(coupon_params)
    @new_coupon.status = "deactivated"
    # require 'pry'; binding.pry
    if @merchant.valid_coupons(@new_coupon.code) && @new_coupon.save
      @new_coupon.update(status: 1)
      redirect_to "/merchants/#{@merchant.id}/coupons"
      flash[:notice] = "Activated Coupon Successfully Created"
    elsif
      @merchant.code_exists?(@new_coupon.code) == true
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "ERROR - VALID DATA MUST BE ENTERED FOR COUPON CREATION"
    elsif 
      @new_coupon.save
      @new_coupon.status = "deactivated"
      redirect_to "/merchants/#{@merchant.id}/coupons"
      flash[:notice] = "Deactivated Coupon Successfully Created"
    else
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "ERROR - VALID DATA MUST BE ENTERED FOR COUPON CREATION"
    end
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    if @coupon.status == "activated"
      @coupon.update(status: 0)
    elsif @coupon.status == "deactivated"
      @coupon.update(status: 1)
    end
    redirect_to "/merchants/#{@merchant.id}/coupons/#{@coupon.id}"
    flash[:notice] = "Coupon Status Successfully Updated"
  end

  private
  def coupon_params
    params.permit(:name, :code, :amount, :disc_type)
  end
end