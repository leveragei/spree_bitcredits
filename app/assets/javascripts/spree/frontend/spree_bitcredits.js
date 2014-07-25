var SpreeBitCredits = window.SpreeBitCredits || {};

SpreeBitCredits.init = function (total) {
        window.BitCredits = window.BitCredits || [];
        window.BitCredits.push(["launchPayment", {
            node:       "#bitcredit_widget",
            amount:     total,
            email:      SpreeBitCredits.user_email,
            colorTheme: "#0ACBCD",
            headerPaid: "Please Save and Continue"
        }]);
};

window.SpreeBitCredits = SpreeBitCredits;

$(document).ready(function () {

    var pageScript   = document.getElementsByTagName('script')[0],
        newScript    = document.createElement('script'),
        host         = "https://api.bitcredits.io",
        $bitCoinCheck = $('input:radio:checked[id^="order_payments_attributes__payment_method_id_"]');

    if (SpreeBitCredits.rails_env == "staging") {
        host = "https://stage-api.bitcredits.io";
    }

    newScript.type  = 'text/javascript';
    newScript.async = true;
    newScript.src   = host + "/v1/bitcredits.js";
    pageScript.parentNode.insertBefore(newScript, pageScript);

    if ($bitCoinCheck.val() == SpreeBitCredits.paymentMethodID) {
        SpreeBitCredits.init(SpreeBitCredits.total);
    }

    $('input:radio[id^="order_payments_attributes__payment_method_id_"]').bind("click", function () {
            if ($(this).val() == SpreeBitCredits.paymentMethodID) {
                SpreeBitCredits.init(SpreeBitCredits.total);
            }
        }
    );
});