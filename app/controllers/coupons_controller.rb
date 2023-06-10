class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
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
    if @merchant.coupon_limit_5 == true && @new_coupon.save
      @new_coupon.status = "activated"
      redirect_to "/merchants/#{@merchant.id}/coupons"
      flash[:notice] = "Activated Coupon Successfully Created"
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

  private
  def coupon_params
    params.permit(:name, :code, :amount, :disc_type)
  end
end