_ = require "underscore"
async = require "async"

class Publisher

  # @property {Object}
  channels: undefined

  constructor: ->
    @channels = []

  addChannel: (newch) ->
    @channels.push newch

  send: (msg) ->

    # sending the message to every subscribers (async mode)
    async.each(
      @channels,
      (ch) =>
        ch.publish(msg)
        (err) ->
          # do nothing
      )

exports.Publisher = Publisher