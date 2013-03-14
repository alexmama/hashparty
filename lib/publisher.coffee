{Peer} = require "./peer"
async = require "async"

class Publisher extends Peer

  # @property {Object}
  channels: undefined

  constructor: ->
    @channels = []

  addChannel: (newch) ->
    @channels.push newch

  send: (msg) ->

    # sending the message to every channels (async mode)
    async.each(
      @channels,
      (ch) =>
        ch.publish(msg)
        (err) ->
          # do nothing
      )

exports.Publisher = Publisher