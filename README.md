
### PayPal Classic API bindings for Node.js

This is a wrapper for PayPal "Classic" NVP API: https://developer.paypal.com/docs/classic/

### Installation
```
npm install paypal-classic-api --save
```
### Usage
**class PayPal(options)**

`options` object fields: `username`, `password` and `signature` from PayPal developer account.

*method* **call(methodName, methodArguments, callback)**

Methods names and arguments information can be found at https://developer.paypal.com/docs/classic/api/ under "Express Checkout API Operation"

### Example
```javascript
PayPal = require('paypal-classic-api');

var credentials = { username: 'tok261_biz_api.abc.com',
                    password: '1244612379',
                    signature: 'lkfg9groingghb4uw5' };
                    
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
[ { TIMESTAMP: '2015-02-27T04:00:01Z',
    TIMEZONE: 'GMT',
    TYPE: 'Payment',
    EMAIL: 'developer@paypal.com',
    NAME: 'Developer',
    TRANSACTIONID: '0JL138973J4267114',
    STATUS: 'Completed',
    AMT: '100',
    CURRENCYCODE: 'JPY',
    FEEAMT: '-44',
    NETAMT: '56' },
  { TIMESTAMP: '2015-02-27T03:53:21Z',
    TIMEZONE: 'GMT',
    TYPE: 'Payment',
    EMAIL: 'developer@paypal.com',
    NAME: 'Developer',
    TRANSACTIONID: '0Y730605XS335043T',
    STATUS: 'Completed',
    AMT: '-12.00',
    CURRENCYCODE: 'USD',
    FEEAMT: '-0.06',
    NETAMT: '-12.06' },
  { TIMESTAMP: '2015-02-27T03:41:24Z',
    TIMEZONE: 'GMT',
    TYPE: 'Transfer',
    NAME: 'PayPal',
    TRANSACTIONID: '65L489117V5191606',
    STATUS: 'Completed',
    AMT: '500.00',
    CURRENCYCODE: 'USD',
    FEEAMT: '0.00',
    NETAMT: '500.00' } ]
```
