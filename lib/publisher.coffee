{Peer} = require "./peer"
async = require "async"
zmq = require "zmq"
_ = require "underscore"

class Publisher extends Peer

  # @property {Object}
  channels: undefined

  constructor: (p_barename, p_tracker) ->
    super(p_barename, p_tracker)
    @channels = []

  addChannel: (newch) ->
    pubsocket = zmq.socket "pub" # "push"
    pubsocket.connect newch.in_endpoint
    @channels.push {channel: newch , socket: pubsocket}

  send: (msg) ->
    # sending the message to every channels (async mode)
    async.each(
      @channels,
      (ch) =>
        #ch.channel.publish(msg)
        ch.socket.send(msg)
        (err) ->
          # do nothing
          console.log err
      )

  clean: ->
    super
    _.each(@channels, (props) ->
          props.socket.close()
          )

exports.Publisher = Publisher