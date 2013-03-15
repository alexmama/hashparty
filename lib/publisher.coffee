{Peer} = require "./peer"
async = require "async"

class Publisher extends Peer

  # @property {Object}
  channels: undefined

  constructor: (p_barename, p_tracker) ->
    super(p_barename, p_tracker)
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