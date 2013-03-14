HashRing = require "hashring"
{Peer} = require "./peer"
_ = require "underscore"

class Subscriber extends Peer

  # @property {Object}
  subscribers: undefined
  ring: undefined
  msgCount: undefined

  constructor: (p_barename, tracker) ->
    super(p_barename, tracker)
    @subscribers = []
    @subscribers.push @fullname
    @ring = new HashRing(@fullname)
    @msgCount = 0

  subscribe: (p_channel) ->
    @discoverFriendsSubscriptions(p_channel)
    # listening to message published on the channel
    p_channel.on "message.copy", (p_message) =>
      if @fullname is @ring.get(p_message)
        console.log "'#{p_message}' processed by #{@fullname}"
        @msgCount++

  discoverFriendsSubscriptions: (p_channel) ->
    # registering any subscriber that may appear
    # TODO: use specialized multicast discovery channel for this purpose)
    @tracker.on "sub.#{p_channel.barename}.*.#{@barename}.*", (p_subscription) =>
      # a new subscription has come, but maybe it is mine or it is not the first time I see it
      if not _.contains(@subscribers, p_subscription.full)
        # it is the first time and it is not me, we add it as a friend...
        @addFriendSub(p_subscription.full)
        #...then I reply him, and all others (including myself), with my own status
        # TODO: reply using a single direct connection rather than broadcast)
        @tracker.emit("sub.#{p_channel.fullname}.#{@fullname}", full: @fullname)

    # now first advertise peers that it comes, i should normally receive a copy
    # TODO: use specialized multicast discovery channel for this purpose)
    @tracker.emit("sub.#{p_channel.fullname}.#{@fullname}", full: @fullname)

  addFriendSub: (p_fullname) ->
    console.log "'#{@fullname}' detected subscription of a clone '#{p_fullname}' to channel 'X'"
    @subscribers.push p_fullname
    @ring.add p_fullname

#  removeFriend: (friendId) ->
#    @ring.remove friendId
#
#  onMessage: (message) ->
#    if @fullname is @ring.get(message)
#      console.log "'#{message}' processed by #{@fullname}"
#      @msgCount++

exports.Subscriber = Subscriber