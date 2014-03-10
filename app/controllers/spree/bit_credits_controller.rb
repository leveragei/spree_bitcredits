module Spree
  class BitCreditsController < StoreController

    def save_balance
      return if current_order.nil?

      Rails.logger.info(cookies[:bitc] )
      if session[:bitcredits_old_balance].blank?
        session[:bitcredits_old_balance] = params[:balance].to_f  unless ( params[:balance].nil?)
      end

      if( params[:balance] != session[:bitcredits_old_balance] )
        session[:bitcredits_new_balance] = params[:balance]
      end

      session[:bitcredits_cockie] = params[:bitc] unless params[:bitc].nil?
      render  :js => "Saved" 

    end
    def get_balance
       token = cookies[:bitc]
       render :js => "no cookie" if token.nil?

       payment_method =  Spree::PaymentMethod.find(:first, :conditions => [ "lower(name) LIKE ?", '%bitcoin%' ])
       
       unless payment_method.nil?
          begin
              url  = URI.parse("#{payment_method.preferred_api_server}v1/accounts/token/#{token}")
              Rails.logger.info(url)
              http = Net::HTTP.new(url.host, url.port)
              http.use_ssl = true
              request = Net::HTTP::Get.new(url.path)
              request.basic_auth(payment_method.preferred_key, "")
              response = http.request(request)
              Rails.logger.info(response.body)
              result = JSON.parse(response.body)


              if( result["status"] == "success")
                session[:bitcredits_old_balance] = result['balance'].to_f  if session[:bitcredits_old_balance].blank?
              end
          rescue  Exception => ex
            Rails.logger.info ex.to_s
            render  :js => ex.to_s
          end

       end
       render  :js => "Saved"
    end
  end
end
