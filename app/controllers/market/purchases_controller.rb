class Market::PurchasesController < ApplicationController

  before_action :authenticate_user!

  before_action :load_data

  def create

    if current_user.get_profile_percent < 100
      redirect_to edit_account_user_path(current_user), alert: "¡Para contactar vendedores debes completar tu perfil!"
      return
    end

    @purchase = current_user.purchases.new params_permit_create
    if @purchase.publication.user == current_user
      redirect_to market_publication_path(@purchase.publication), alert: "Opps, no puedes comprar en una publicación tuya."
      return
    end
    if @purchase.save
      Notification.create_and_send(Notification::BUY_CONTACT, @purchase, current_user)
      Notification.create_and_send(Notification::SALE_CONTACT, @purchase, @purchase.publication.user)
      if @purchase.publication.subject == Publication::PRODUCTOS
        redirect_to market_publication_path(@purchase.publication), notice: "¡Excelente! ponte en contacto con el vendedor para concretar la compra, no olvides que dar click en comprar es un compromiso."
      else
        redirect_to market_publication_path(@purchase.publication), notice: "¡Excelente! te has contactado con el vendedor, pronto recibiras respuesta o llámalo"
      end
    else
      redirect_to market_publication_path(params[:purchase][:publication_id]), alert: "Para contactar al vendedor, debes escribir algo en la consulta."
    end
  end

  private

  def load_data
    @subtitle = "Compras"
  end

  def params_permit_create
    params.require(:purchase).permit(:units, :consult, :publication_id)
  end

end
