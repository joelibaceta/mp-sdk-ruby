Mercadopago.setPublishableKey("TEST-98638d24-eb00-4dd5-82d8-4e573fac6a80");


var paymentForm = function(formSelector){

    var formSelector = formSelector;
    var doSubmit = false;
    var getCurrentForm = function(){ return document.querySelector(formSelector) };

    var getInputFromDataCheckoutAttr = function(dataCheckout){
        form = getCurrentForm();
        return form.querySelector('input[data-checkout="' + dataCheckout + '"]');
    };

    var getInputFromID = function(id){
        form = getCurrentForm();
        return form.querySelector('#' + id);
    };

    var getCurrentFormAsHash = {
        cardNumber: getInputFromDataCheckoutAttr('cardNumber')
    };

    var getBin = function(){
        formHash = getCurrentFormAsHash;
        ccNumber = formHash.cardNumber;
        return ccNumber.value.replace(/[ .-]/g, '').slice(0, 6);
    };

    var clearOptions = function(){

    }

    var cardsInitializer = function() {
        clearOptions();
        var cardSelector = getInputFromID("cardId")
        var amount = getInputFromID('amount').value;

        if (cardSelector && cardSelector[cardSelector.options.selectedIndex].value != "-1") {
            var _bin = cardSelector[cardSelector.options.selectedIndex].getAttribute("first_six_digits");
            Mercadopago.getPaymentMethod({
                "bin": _bin
            }, setPaymentMethodInfo);
        }
    };



    var setInstallmentsByIssuerId = function(status, response) {
        var issuerId = getInputFromID('issuer').value;
        var amount = getInputFromID('amount').value;

        if (issuerId === '-1') {
            return;
        }

        Mercadopago.getInstallments({
            "bin": getBin(),
            "amount": amount,
            "issuer_id": issuerId
        }, setInstallmentInfo);
    };

    var setPaymentMethodInfo = function(status, response) {
        if (status == 200) {

            console.log(response);
            // do somethings ex: show logo of the payment method
            form = getCurrentForm();

            if (getInputFromDataCheckoutAttr('paymentMethodId') == null) {
                var paymentMethod = document.createElement('input');
                paymentMethod.setAttribute('name', "paymentMethodId");
                paymentMethod.setAttribute('data-checkout', "paymentMethodId");
                paymentMethod.setAttribute('type', "hidden");
                paymentMethod.setAttribute('value', response[0].id);
                form.appendChild(paymentMethod);
            } else {
                getInputFromDataCheckoutAttr('paymentMethodId').value = response[0].id;
            }

            if (getInputFromID("amount")){
                var cardConfiguration = response[0].settings,
                    bin = getBin(),
                    amount = getInputFromID("amount").value

                for (var index = 0; index < cardConfiguration.length; index++) {
                    if (bin.match(cardConfiguration[index].bin.pattern) != null && cardConfiguration[index].security_code.length == 0) {

                    } else {

                    }
                }


                Mercadopago.getInstallments({
                    "bin": bin,
                    "amount": amount
                }, setInstallmentInfo);

                var issuerMandatory = false;
                var additionalInfo = response[0].additional_info_needed;

                console.log(additionalInfo);

                for (var i = 0; i < additionalInfo.length; i++) {
                    if (additionalInfo[i] == "issuer_id") {
                        issuerMandatory = true;
                    }
                };

                if (issuerMandatory) {
                    Mercadopago.getIssuers(response[0].id, showCardIssuers);
                    addEvent(getInputFromID("issuer"), 'change', setInstallmentsByIssuerId);
                } else {
                    getInputFromID("issuer").style.display = 'none';
                    getInputFromID("issuer").options.length = 0;
                }

            }

        }
    };

    var guessPaymentMethod = function(event) {

        var bin = getBin();

        if (event.type == "keyup") {
            if (bin.length >= 6) {
                Mercadopago.getPaymentMethod({
                    "bin": bin
                }, setPaymentMethodInfo);
            }
        } else {
            setTimeout(function() {
                if (bin.length >= 6) {
                    Mercadopago.getPaymentMethod({
                        "bin": bin
                    }, setPaymentMethodInfo);
                }
            }, 100);
        }
    };

    this.showCardIssuersFn = function(status, issuers) {
        return showCardIssuers(status, issuers);
    };

    this.setInstallmentInfoFn = function(bin, amount) {
        Mercadopago.getInstallments({
            "bin": bin,
            "amount": amount
        }, setInstallmentInfo);
    };


    var showCardIssuers = function(status, issuers) {
        console.log(issuers);
        var issuersSelector = getInputFromID("issuer");
        var fragment = document.createDocumentFragment();

        issuersSelector.options.length = 0;
        var option = new Option("Choose...", '-1');
        fragment.appendChild(option);

        for (var i = 0; i < issuers.length; i++) {
            if (issuers[i].name != "default") {
                option = new Option(issuers[i].name, issuers[i].id);
            } else {
                option = new Option("Otro", issuers[i].id);
            }
            fragment.appendChild(option);
        }
        issuersSelector.appendChild(fragment);
        issuersSelector.removeAttribute('disabled');
        getInputFromID("issuer").removeAttribute('style');
    };


    var setInstallmentInfo = function(status, response) {
        var selectorInstallments = getInputFromID("installments"),
            fragment = document.createDocumentFragment();

        selectorInstallments.options.length = 0;

        if (response.length > 0) {
            var option = new Option("Choose...", '-1'),
                payerCosts = response[0].payer_costs;

            fragment.appendChild(option);
            for (var i = 0; i < payerCosts.length; i++) {
                option = new Option(payerCosts[i].recommended_message || payerCosts[i].installments, payerCosts[i].installments);
                fragment.appendChild(option);
            }
            selectorInstallments.appendChild(fragment);
            selectorInstallments.removeAttribute('disabled');
        }
    };

    var initialize = function(){
        addEvent(getCurrentForm(), 'submit', doPay);
        if (getCurrentFormAsHash.cardNumber) {
            addEvent(getCurrentFormAsHash.cardNumber, 'keyup', guessPaymentMethod);
            addEvent(getCurrentFormAsHash.cardNumber, 'change', guessPaymentMethod);
            addEvent(getCurrentFormAsHash.cardNumber, 'keyup', clearOptions);
        }
    };

    var doPay = function(event){
        event.preventDefault();
        if(!doSubmit){
            Mercadopago.createToken(getCurrentForm(), createTokenCallback);
            return false;
        }
    };

    var createTokenCallback = function(status, response) {
        if (status != 200 && status != 201) {
        }else{
            var form = getCurrentForm();
            var card = document.createElement('input');
            card.setAttribute('name',"token");
            card.setAttribute('type',"hidden");
            card.setAttribute('value',response.id);
            form.appendChild(card);
            doSubmit=true;
            form.submit();
        }
    };

    initialize();

}

