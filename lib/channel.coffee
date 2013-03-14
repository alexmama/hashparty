{Peer} = require "./peer"

class Channel extends Peer

  constructor: (p_barename, channel) ->
    super(p_barename, channel)

  publish: (p_message) ->
    # republishing every message to subcribers
    @emit("message.copy", p_message)

exports.Channel = Channel