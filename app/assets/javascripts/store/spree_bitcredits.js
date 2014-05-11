//= require store/spree_frontend

SpreeBitCredits = {
  init : function(total){
          window.BitCredits = window.BitCredits || [];
         // window.BitCredits.push(["startBalancePolling"]);
      //    var bitc =  readCookie("bitc");
      //    window.BitCredits.restoreToken(bitc)
          window.BitCredits.push(["launchPayment", {
              amount: total,
              node: "#bitcredit_widget",
              email: SpreeBitCredits.user_email,
              colorTheme : "#0ACBCD",
              headerPaid: "Please Save and Continue"}]);

      //   $.getScript('/bitcredits/getBalance');


  }

}

$(document).ready(function() {
        var d = document, f = d.getElementsByTagName('script')[0],
        s = d.createElement('script');
        host = "https://api.bitcredits.io"
       

        if( SpreeBitCredits.rails_env == "staging")
           host = "https://stage-api.bitcredits.io";


        s.type = 'text/javascript';s.async = true;s.src = host + "/v1/bitcredits.js";
        f.parentNode.insertBefore(s, f);

        var bitCoinCheck = $('input:radio:checked[id^="order_payments_attributes__payment_method_id_"]');
        if( bitCoinCheck.val()  == SpreeBitCredits.paymentMethodID   )
          SpreeBitCredits.init( SpreeBitCredits.total);

        $('input:radio[id^="order_payments_attributes__payment_method_id_"]').bind("click", function() {
          if( $( this ).val()  == SpreeBitCredits.paymentMethodID ){
             SpreeBitCredits.init( SpreeBitCredits.total);
        }

       }
     );

})