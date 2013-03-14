HashRing = require "hashring"
{Peer} = require "./peer"

class Subscriber extends Peer

  # @property {Object}
  ring: undefined
  msgCount: undefined

  constructor: (p_barename) ->
    super(p_barename)
    @ring = new HashRing(@fullname)
    @msgCount = 0

  subscribe: (channel) ->
    channel.addSubscriber(@)

  addFriend: (friendId) ->
    @ring.add friendId

  removeFriend: (friendId) ->
    @ring.remove friendId

  onMessage: (message) ->
    if @fullname is @ring.get(message)
      console.log "'#{message}' processed by #{@fullname}"
      @msgCount++
    #else
    #  console.log "Subscriber #{@id} DROPPED msg '#{message}'"

exports.Subscriber = Subscriber