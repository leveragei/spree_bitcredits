module Spree
  module PermittedAttributes
    @@payment_attributes.push :source, :payment_method , :response_code, :preferred_key, :preferred_api_server
  end
end