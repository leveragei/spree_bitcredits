module Spree
  CheckoutController.class_eval do
    after_filter :create_bitcredits_payment, :only => [:update]

    def payment_method
      Spree::PaymentMethod.find(:first, :conditions => [ "lower(name) LIKE ?", '%bitcoin%' ]) || raise(ActiveRecord::RecordNotFound)
    end

    def create_bitcredits_payment
      return unless (params[:state] == "payment")
      return unless params[:order][:payments_attributes]

      return unless Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id]).kind_of?(Spree::Gateway::BitCredits)


      source = Spree::BitCreditsCheckout.create()
      payment = @order.payments.where(:state => "checkout",
                                      :payment_method_id => payment_method.id).first

      if payment
        payment.source =  source
        payment.save
      else
        payment = @order.payments.create(:amount => @order.total,
                                         :source =>  source,
                                         :payment_method => payment_method)
      end
      # save data from bitcredits 
      source.update_attribute(:old_balance , session[:bitcredits_old_balance])
      source.update_attribute(:source,cookies[:bitc])
    #  source.update_attribute(:new_balance , session[:bitcredits_new_balance])  unless( session[:bitcredits_old_balance].blank? )
            
      end

  end
end
