class Account::PurchasesController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }
  
  before_action :load_data

  def index
    if params[:as] == "buyer"
      @purchases = current_user.purchases.order(created_at: :desc)
    else
      @purchases = Purchase.by_seller(current_user).order(created_at: :desc)
    end
    unless params[:only_not_reviewd].nil?
      if params[:as] == "buyer"
        @purchases = current_user.purchases.seller_not_rated.order(created_at: :desc)
      else
        @purchases = Purchase.buyer_not_rated(current_user).order(created_at: :desc)
      end
    end
  end

  def show
    @purchase = current_user.purchases.find_by_id params[:id]
    @agent = "buyer"
    if @purchase.nil?
      @agent = "seller"
      @purchase = Purchase.by_seller(current_user).find params[:id]
    end
  end

  def mark_as_charged
    @purchase = Purchase.by_seller(current_user).find params[:id]
    if @purchase.charge_status == true
      @purchase.update_attribute :charge_status, false
      Notification.create_and_send(Notification::MARK_AS_CHARGED, @publication, current_user)
      redirect_to account_purchases_path(as: "seller"), notice: "Venta marcada como cobrada."
    else
      @purchase.update_attribute :charge_status, true
      redirect_to account_purchases_path(as: "seller"), alert: "Venta marcada como no cobrada."
    end
  end

  def mark_as_sent
    @purchase = Purchase.by_seller(current_user).find params[:id]
    if @purchase.send_status == true
      @purchase.update_attribute :send_status, false
      Notification.create_and_send(Notification::MARK_AS_SENT, @publication, current_user)
      redirect_to account_purchases_path(as: "seller"), notice: "Venta marcada como despachada."
    else
      @purchase.update_attribute :send_status, true
      redirect_to account_purchases_path(as: "seller"), alert: "Venta marcada como no despachada."
    end
  end

  def mark_as_payed
    @purchase = current_user.purchases.find params[:id]
    if @purchase.pay_status == true
      @purchase.update_attribute :pay_status, false
      Notification.create_and_send(Notification::MARK_AS_PAYED, @publication, current_user)
      redirect_to account_purchases_path(as: "buyer"), notice: "Venta marcada como pagada."
    else
      @purchase.update_attribute :pay_status, true
      redirect_to account_purchases_path(as: "buyer"), alert: "Venta marcada como no pagada."
    end
  end

  def load_data
    @not_show_main_banner = true
  end

end
