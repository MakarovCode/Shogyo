class Account::ReputationsController < ApplicationController
  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }
  
  before_action :load_data

  def index
    @user = current_user
    @as_buyer = {positives: 0, neutral: 0, negatives: 0, total: 0}
    @as_seller = {positives: 0, neutral: 0, negatives: 0, total: 0}

    @apply_for_certification = current_user.purchases.positives.count >= 3

    @purchases_as_buyer = current_user.purchases.order(created_at: :desc).seller_rated.page(1).per(20)
    @purchases_as_seller = Purchase.buyer_rated(current_user).order(created_at: :desc).page(1).per(20)

    total = @purchases_as_buyer.count > 0 ? @purchases_as_buyer.count : 1

    @as_buyer[:positives] = (@purchases_as_buyer.positives.count*100)/total
    @as_buyer[:neutrals] = (@purchases_as_buyer.neutrals.count*100)/total
    @as_buyer[:negatives] = (@purchases_as_buyer.negatives.count*100)/total
    @as_buyer[:total] = @purchases_as_buyer.count

    @as_seller[:positives] = (@purchases_as_seller.positives.count*100)/total
    @as_seller[:neutrals] = (@purchases_as_seller.neutrals.count*100)/total
    @as_seller[:negatives] = (@purchases_as_seller.negatives.count*100)/total
    @as_seller[:total] = @purchases_as_seller.count

    @show_reputation_as_buyer = @purchases_as_buyer.count >= 3
    @show_reputation_as_seller = @purchases_as_seller.count >= 3
  end

  def new
    if params[:as] == "buyer"
      @purchase = current_user.purchases.find params[:id]
    else
      @purchase = Purchase.by_seller(current_user).find params[:id]
    end
  end

  def update
    puts "=====>IN"
    if params[:as] == "buyer"
      @purchase = current_user.purchases.find params[:id]
      @purchase.reviewed = true
      if @purchase.update params_permit
        @purchase.publication.check_if_ended(@purchase)
        Notification.create_and_send(Notification::SELLER_QUALIFICATION, @purchase, @purchase.publication.user)
        redirect_to account_purchases_path(as: "buyer", only_not_reviewd: true), notice: "¡Compra valificada correctamente!"
      else
        render :new
      end
    else
      @purchase = Purchase.by_seller(current_user).find params[:id]
      @purchase.buyer_reviewed = true
      if @purchase.update params_permit
        @purchase.publication.check_if_ended(@purchase)
        Notification.create_and_send(Notification::BUYER_QUALIFICATION, @purchase, @purchase.user)
        redirect_to account_purchases_path(as: "seller", only_not_reviewd: true), notice: "¡Venta valificada correctamente!"
      else
        render :new
      end
    end
  end

  def load_data
    @not_show_main_banner = true
  end

  private

  def params_permit
    if params[:as] == "buyer"
      params.require(:purchase).permit(:review, :received, :recommended)
    else
      params.require(:purchase).permit(:delivered, :buyer_review, :buyer_recommended)
    end
  end

end
