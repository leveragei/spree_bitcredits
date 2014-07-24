module Spree
  CheckoutController.class_eval do
    after_filter :create_bitcredits_payment, only: [:update]

    def payment_method
      Spree::PaymentMethod.find(:first, conditions: ["lower(name) LIKE ?", '%bitcoin%']) || raise(ActiveRecord::RecordNotFound)
    end

    def create_bitcredits_payment
      state = params[:state]

      return unless state == "payment" && params[:order][:payments_attributes]

      payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

      return unless payment_method.kind_of?(Spree::Gateway::BitCredits)

      source  = Spree::BitCreditsCheckout.create
      payment = @order.payments.where(state: "checkout", payment_method_id: payment_method.id).first

      if payment
        payment.source = source
        payment.save
      else
        @order.payments.create(amount: @order.total, source: source, payment_method: payment_method)
      end

      source.update_attribute(:source, cookies[:bitc])
    end
  end
end
