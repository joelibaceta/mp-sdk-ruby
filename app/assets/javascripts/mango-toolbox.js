// Set your store's public API Key
var PUBLIC_API_KEY = 'public_test_ue2q6tkziyqige6vfs6hnd6fc5g3benq';

// Configure the JavaScript SDK with your API Key
Mango.setPublicKey(PUBLIC_API_KEY);

var mangoPaymentForm=function(formSelector){

    var submission = false;

    console.log(formSelector);

    console.log(document.querySelector(formSelector));

    var getCurrentForm = function(){ return document.querySelector(formSelector)};

    var getInputFromID = function(id){
        form = getCurrentForm();
        return form.querySelector('#' + id);
    };

    // Define the callback function


    var handleResponse = function (err, data) {
        submission = false;


        // If there is an error, show a message
        if (err) {
            // Show messsage

            console.log(err);
            for (var msg in (err.errors[0])) {
                console.log(err.errors[0][msg]);
                $(".alert").show();
                $(".alert").html(err.errors[0][msg]);

            }
        } else {
            // Get the token uid
            var token = data.uid;

            // Create an input hidden

            var tokenInput = document.createElement('input');
            tokenInput.setAttribute('name',"token");
            tokenInput.setAttribute('type',"hidden");
            tokenInput.setAttribute('value',token);

            // Add the input hidden to the form
            getCurrentForm().appendChild(tokenInput);

            // Submit it
            getCurrentForm().submit();
        }


    }

    var submitHandler = function(event) {

        event.preventDefault();

        // Prevents multiple form submission
        if (submission) {
            return false;
        }

        submission = true;


        // Get credit card information
        var cardInfo = {
            'number': getInputFromID('cardNumber').value.replace(/[ .-]/g, ''),
            'type': getInputFromID('cardType').value,
            'holdername': getInputFromID('cardholderName').value,
            'exp_month': getInputFromID('cardExpirationMonth').value,
            'exp_year': getInputFromID('cardExpirationYear').value,
            'ccv': getInputFromID('securityCode').value
        };

        // Create the token
        Mango.token.create(cardInfo, handleResponse);



        // Prevents submit event
        return false;

    };

    addEvent(getCurrentForm(), 'submit', submitHandler);

}