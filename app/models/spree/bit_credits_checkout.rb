module Spree
  class BitCreditsCheckout < ActiveRecord::Base
   attr_accessible :old_balance,:new_balance , :source

  end
end
