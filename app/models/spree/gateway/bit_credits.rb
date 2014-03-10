
module Spree
  class Gateway::BitCredits < Gateway
 #   preference :bitcredits_id, :string
    preference :key, :string
 #   preference :total,:string
    preference :api_server,:string

    attr_accessible :preferred_key,:preferred_api_server



    def supports?(source)
      true
    end

    def payment_profiles_supported?
      true
    end

    def auto_capture?
      true
    end


    def method_type
      'bitcredits'
    end
    def payment_source_class
      Spree::BitCreditsCheckout
    end
    def provider_class
      self.class
    end

    def provider
    #/ self.api_key = preferred_key
      self.api_server = self.preferred_api_server


      provider_class
    end

    def purchase(amount, bitcredits_checkout, gateway_options={})
      begin
      
        order_id = gateway_options[:order_id].split('-')[0]
        payment_id = gateway_options[:order_id].split('-')[1]
        @payment = Spree::Payment.find_by_identifier(payment_id)


#        if( bitcredits_checkout.new_balance > 0  )
          #check if it was paid  from wallet or from phone
          url  = URI.parse("#{@payment.payment_method.preferred_api_server}v1/accounts/token/#{bitcredits_checkout.source}")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          request = Net::HTTP::Get.new(url.path)
          request.basic_auth(@payment.payment_method.preferred_key, "")
          response = http.request(request)
          Rails.logger.info(response.body)
          result = JSON.parse(response.body)


          if( result["status"] == "success")
              bitcredits_checkout.update_attribute(:new_balance ,result['balance'].to_f )

              paid_sum = bitcredits_checkout.new_balance - bitcredits_checkout.old_balance

              if paid_sum == @payment.order.total
               @payment.complete!
               @payment.log_entries.create(:details => "Instant-type BitCredits transaction. Payment marked as completed.
                                                        old balance #{bitcredits_checkout.old_balance}  new balance #{bitcredits_checkout.new_balance}")
               return  ActiveMerchant::Billing::Response.new(true,Spree.t(:checkout_success, :scope => :bitcredits))
              else
                   # make transaction to BitCredits
                    url  = URI.parse("#{@payment.payment_method.preferred_api_server}v1/transactions")
                    req = Net::HTTP::Post.new(url.path)
                    req.basic_auth(@payment.payment_method.preferred_key, "")
                    req["Content-Type"] = "application/json"
                    req["Accept"] = "application/json"
                    req.body = '{"src_token":"' + bitcredits_checkout.source + '","dst_account":"\/coryvines\/order\/' + @payment.order.number +
                      '","dst_account_create":true,"amount":"' + @payment.order.total.to_s + '"}'


                    con = Net::HTTP.new(url.host, url.port)
                    con.use_ssl = true

                    res = con.start {|http| http.request(req) }
                    result = JSON.parse(res.body)


                    if( result["status"] == "success")
                       @payment.complete!
                       @payment.log_entries.create(:details => "Instant-type BitCredits transaction.
                                  Payment marked as completed. response from BitCredits #{result["status"]}  and tax_id #{result["tx_id"]}")

                       ActiveMerchant::Billing::Response.new( true, Spree.t(:checkout_success, :scope => :bitcredits) )
                    else
                      @payment.failure!
                      @payment.log_entries.create(:details => "Instant-type BitCredits transaction.
                                  Payment marked as failed. response from BitCredits  andr error #{result["message"]}")

                      ActiveMerchant::Billing::Response.new( false, Spree.t(:checkout_failure, :scope => :bitcredits), { :message => "BitCredits failed: #{result["message"]}" })
                    end



              end
              
           else
               @payment.failure!
               @payment.log_entries.create(:details => "Instant-type BitCredits transaction. Payment marked as failed. order is #{@payment.order.total}
                             error #{result["message"]}  old balance #{bitcredits_checkout.old_balance}  new balance #{bitcredits_checkout.new_balance}")
               ActiveMerchant::Billing::Response.new( false, Spree.t(:checkout_failure, :scope => :bitcredits), { :message => "BitCredits failed: #{result["message"]}" })
           end
  #      end

              # make transaction to BitCredits



      rescue => exception
        @payment.log_entries.create(:details => "Oops. Something went wrong. Spree said: #{exception}")
        @payment.failure!
         Rails.logger.info(exception);
        ActiveMerchant::Billing::Response.new(false, Spree.t(:checkout_failure, :scope => :bitcredits), { :message => "Something went wrong: #{exception}" } )
     end
    end
  end
end
