request = require 'request'
querystring = require 'querystring'
_ = require 'underscore'
util = require 'util'

API_URL = 'https://api-3t.sandbox.paypal.com/nvp'

class PayPal

  constructor: (options) ->
    @username = options.username
    @password = options.password
    @signature = options.signature

  call: (method, parameters, callback) =>

    processResponse = (text) ->

      data = querystring.decode text
      if not data
        callback? 'invalid server response'

      params = ((k for k of data).map (key) ->
        parts = /L_([A-Z]+)(\d+)/.exec(key)
        return if parts then [parts[1], parseInt(parts[2]), key] else [])
          .filter (p) -> p[0] and (p[1] != null and typeof p[1] != 'undefined')

      ids = (_.uniq _.flatten (p[1] for p in params)).filter (p) -> typeof p != 'undefined'

      ids.map (id) ->
        obj = {}
        for param in params
          if id == param[1]
            obj[param[0]] = data[param[2]]
        return obj

    args = {
      USER: @username,
      PWD: @password,
      SIGNATURE: @signature,
      METHOD: method,
      VERSION: 94,
    }

    for k, v of parameters
      args[k] = v

    request.post { url: API_URL, body: querystring.encode args }, (error, response, body) ->
      if error
        return callback?error

      callback? null, processResponse body

module.exports = PayPal


#(new exports(USERNAME, PASSWORD, SIGNATURE)).call 'TransactionSearch', { StartDate: START_DATE }, (error, transactions) ->
  #console.log error, transactions

