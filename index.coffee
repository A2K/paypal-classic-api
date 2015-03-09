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

      response = {}

      extractValue = (key, value) ->
        if not isNaN(value)
          value = parseFloat(value)
        if key == 'TIMESTAMP' or /.+DATE$/.test key
          date = new Date(value)
          value = date if date and not isNaN date.getYear()
        return value

      for key in ((k for k of data).filter (k) -> /^[A-Z]+$/.test(k))
        response[key] = extractValue(key, data[key])

      rx = /^L_([A-Z]+)(\d+)$/

      params = ((k for k of data).map (key) ->
        return if not rx.test(key)
        parts = rx.exec(key)
        if parts then [parts[1], parseInt(parts[2]), key] else null
      ).filter (p) -> p?

      ids = (p[1] for p in params)
      ids = _.uniq _.flatten ids


      response["objects"] = ids.map (id) ->
        obj = {}
        for param in params
          if id == param[1]
            obj[param[0]] = extractValue param[0], data[param[2]]
        return obj

      return response

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

