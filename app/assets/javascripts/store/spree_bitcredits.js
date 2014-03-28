//= require store/spree_core
function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}
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
        host = "https://stage-api.bitcredits.io";

        if( SpreeBitCredits.rails_env == "production")
          host = "https://api.bitcredits.io"


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