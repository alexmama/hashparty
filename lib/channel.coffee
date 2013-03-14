_ = require "underscore"
async = require "async"
{Peer} = require "./peer"

class Channel extends Peer

  constructor: (p_barename) ->
    super(p_barename)
    # @subscribers = []

  publish: (p_message) ->
    # republishing every message to subcribers
    @emit("message.copy", p_message)

exports.Channel = Channel