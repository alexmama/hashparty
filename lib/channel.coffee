{Peer} = require "./peer"
zmq = require "zmq"

class Channel extends Peer

  in_socket: undefined
  in_endpoint: undefined
  out_socket: undefined
  out_endpoint: undefined

  constructor: (p_barename, channel) ->
    super(p_barename, channel)
    @out_socket = zmq.socket "xpub"
    @out_endpoint = "tcp://127.0.0.1:#{5000 + Math.floor(Math.random() * 1000)}" # "inproc://#{@fullname}.xpub"
    @out_socket.bindSync @out_endpoint
    @in_socket = zmq.socket "xsub"
    @in_endpoint = "tcp://127.0.0.1:#{5000 + Math.floor(Math.random() * 1000)}" # "inproc://#{@fullname}.xsub"
    @in_socket.bindSync @in_endpoint
    # messages flow
    @in_socket.on "message", (data) => @out_socket.send(data)
    # subscriptions forwarding (for xpub/xsub)
    @out_socket.on "message", (data) => @in_socket.send(data)

  clean: ->
    super
    @in_socket.close()
    @out_socket.close()

exports.Channel = Channel