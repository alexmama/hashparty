HashRing = require "hashring"
{Peer} = require "./peer"
_ = require "underscore"

class Subscriber extends Peer

  # @property {Object}
  friends: undefined
  ring: undefined
  msgCount: undefined

  constructor: (p_barename, tracker) ->
    super(p_barename)
    @friends = []
    @friends.push @fullname
    @ring = new HashRing(@fullname)
    @msgCount = 0
    # registering to friend peers that may come
    # TODO: use specialized multicast discovery channel for this purpose)
    tracker.on "#{@barename}.*", (p_peerstatus) =>
      # a friend has come, but is it me or is it the first time
      if not _.contains(@friends, p_peerstatus.full)
        # it is the first time and it is not me, we add it as a friend...
        @addFriend(p_peerstatus.full)
        #...then I reply him, and all others (including myself), with my own status
        # TODO: reply using a single direct connection rather than broadcast)
        tracker.emit(@fullname, bare: @barename, full: @fullname)

    # now first advertise peers that it comes, i should normally receive a copy
    # TODO: use specialized multicast discovery channel for this purpose)
    tracker.emit(@fullname, bare: @barename, full: @fullname)

  subscribe: (channel) ->
    # listening to message published on the channel
    channel.on "message.copy", (p_message) =>
      if @fullname is @ring.get(p_message)
        console.log "'#{p_message}' processed by #{@fullname}"
        @msgCount++

  addFriend: (p_fullname) ->
    console.log "'#{@fullname}' elected peer '#{p_fullname}' as a friend"
    @friends.push p_fullname
    @ring.add p_fullname

#  removeFriend: (friendId) ->
#    @ring.remove friendId
#
#  onMessage: (message) ->
#    if @fullname is @ring.get(message)
#      console.log "'#{message}' processed by #{@fullname}"
#      @msgCount++

exports.Subscriber = Subscriber