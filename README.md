
### PayPal Classic API bindings for Node.js

This is a wrapper for PayPal "Classic" NVP API: https://developer.paypal.com/docs/classic/

### Installation
```
npm install paypal-classic-api --save
```
### Usage
**class PayPal(options)**

`options` object mandatory fields: `username`, `password` and `signature` from PayPal developer account.

`options`.`live` is an optional field which enables "live" mode. Default value is `false`, so the module will operate in sandbox mode if this field is not explicitly set to `true`.

*method* **call(methodName, methodArguments, callback)**

Methods names and arguments information can be found at https://developer.paypal.com/docs/classic/api/ under "Express Checkout API Operation"

### Example
```javascript
PayPal = require('paypal-classic-api');

var credentials = { username: 'tok261_biz_api.abc.com',
                    password: '1244612379',
                    signature: 'lkfg9groingghb4uw5',
                    live: false }; // false for sandbox mode, true for live mode

var paypal = new PayPal(credentials);

paypal.call('TransactionSearch',
            { StartDate: '2012-06-11T10:50:44.681Z' },
            function (error, transactions) {
  if (error) {
    console.error('API call error: ' + error);
  } else {
    console.log(transactions);
  }
});
```

**Example output**
```javascript
{ TIMESTAMP: Mon Mar 09 2015 16:56:22 GMT-0700 (PDT),
  CORRELATIONID: '584ced41b8ab3',
  ACK: 'Success',
  VERSION: 94,
  BUILD: 15220584,
  objects: [ { TIMESTAMP: Thu Feb 26 2015 20:00:01 GMT-0800 (PST),
               TIMEZONE: 'GMT',
               TYPE: 'Payment',
               EMAIL: 'developer@paypal.com',
               NAME: 'Developer',
               TRANSACTIONID: '0J1L38973J4267114',
               STATUS: 'Completed',
               AMT: 100,
               CURRENCYCODE: 'JPY',
               FEEAMT: -44,
               NETAMT: 56 },
             { TIMESTAMP: Thu Feb 26 2015 19:53:21 GMT-0800 (PST),
               TIMEZONE: 'GMT',
               TYPE: 'Payment',
               EMAIL: 'developer@paypal.com',
               NAME: 'Developer',
               TRANSACTIONID: '07Y30605XS335043T',
               STATUS: 'Completed',
               AMT: -12,
               CURRENCYCODE: 'USD',
               FEEAMT: -0.06,
               NETAMT: -12.06 },
             { TIMESTAMP: Thu Feb 26 2015 19:41:24 GMT-0800 (PST),
               TIMEZONE: 'GMT',
               TYPE: 'Transfer',
               NAME: 'PayPal',
               TRANSACTIONID: '6L2489117V5191606',
               STATUS: 'Completed',
               AMT: 500,
               CURRENCYCODE: 'USD',
               FEEAMT: 0,
               NETAMT: 500 } ]
}
```

