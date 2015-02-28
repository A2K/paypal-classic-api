request = require 'request'
querystring = require 'querystring'
_ = require 'underscore'
util = require 'util'

API_LIVE_URL = 'https://api-3t.paypal.com/nvp'
API_SANDBOX_URL = 'https://api-3t.sandbox.paypal.com/nvp'
API_VERSION = 94

class PayPal

  constructor: (options) ->
    @apiUrl = if options.live then API_LIVE_URL else API_SANDBOX_URL
    @username = options.username
    @password = options.password
    @signature = options.signature

  call: (method, parameters, callback) =>

    processResponse = (text) ->

      data = querystring.decode text

      return (callback? 'invalid server response') if not data?

      params = ((k for k of data).map (key) ->
        parts = /L_([A-Z]+)(\d+)/.exec(key)
        return if parts then [parts[1], parseInt(parts[2]), key] else null)
          .filter (p) -> p?

      ids = (_.uniq _.flatten (p[1] for p in params)).filter (p) -> p?

      ids.map (id) ->
        obj = {}
        for param in params
          if id == param[1]
            value = data[param[2]]
            if not isNaN(value)
              value = parseFloat(value)
            if param[0] == 'TIMESTAMP' or /.+DATE/.test param[0]
              date = new Date(value)
              value = date if date and not isNaN date.getYear()
            obj[param[0]] = value
        return obj

    args = {
      USER: @username,
      PWD: @password,
      SIGNATURE: @signature,
      METHOD: method,
      VERSION: API_VERSION,
    }

    for k, v of parameters
      args[k] = v

    request.post { url: @apiUrl, body: querystring.encode args }, (error, response, body) ->
      if error
        return callback?error

      callback? null, processResponse body

module.exports = PayPal

