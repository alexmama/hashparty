HashRing = require "hashring"
{Peer} = require "./peer"
_ = require "underscore"
zmq = require "zmq"

class Subscriber extends Peer

  # @property {Object}
  channelsubs: undefined

  constructor: (p_barename, tracker) ->
    super(p_barename, tracker)
    @channelsubs = []

  subscribe: (p_channel) ->
    channelSub = {}
    channelSub.subscribers = []
    #add myself in the subscribers list
    channelSub.subscribers.push @fullname
    channelSub.ring = new HashRing(@fullname)
    # Connecting to channel
    channelSub.channelsubsocket = zmq.socket "sub"
    channelSub.channelsubsocket.connect p_channel.out_endpoint # to be resolved by the tracker
    channelSub.channelsubsocket.subscribe('')
    channelSub.channelsubsocket.on "message", (p_message) =>
      if @fullname is channelSub.ring.get(p_message)
        console.log "'#{p_message}' processed by #{@fullname}"
    @channelsubs[p_channel.barename] = channelSub
    @discoverFriendsSubscriptions(p_channel)

  discoverFriendsSubscriptions: (p_channel) ->

    # Enabling subscriptions discovery
    @tracker_outsocket.subscribe("peersub::#{@barename}")
    @on "peersub::#{@barename}.*", (p_subscription) =>
      # TODO: check that it is really a subscription
      # a new subscription of a member of my familly has come, but maybe it is mine or it is not the first time I see it
      if p_channel.barename is @bareFromFull(p_subscription.channelfullname) and not _.contains(
                                              @channelsubs[p_channel.barename].subscribers, p_subscription.publisher)
        # it is the first time and it is not me, we add it as a friend...
        @addFriendSub(p_subscription.publisher, p_channel.barename)
        #...then I reply him, and all others (including myself), with my own sub
        # TODO: reply using a single direct connection rather than broadcast)
        @sendSubToTracker(p_channel.fullname)
    setTimeout( # waiting for 50 millis before starting discovery
      # now will send my state to initiate discover
      => @sendSubToTracker(p_channel.fullname)
    ,50)

  sendSubToTracker: (p_channelfullname) ->
    if @tracker_insocket
      #console.log "sent to tracker: 'peersub::#{@fullname}::#{JSON.stringify(channelfullname: p_channelfullname)}'"
      @tracker_insocket.send "peersub::#{@fullname}::#{JSON.stringify(channelfullname: p_channelfullname)}"

  addFriendSub: (p_fullname, p_channelbarename) ->
    console.log "'#{@fullname}' detected subscription of a clone '#{p_fullname}' to channel '#{p_channelbarename}'"
    channelsub = @channelsubs[p_channelbarename]
    channelsub.subscribers.push p_fullname
    channelsub.ring.add p_fullname

  clean: ->
    super
    console.log @channelsubs
    _.each(@channelsubs, (channelsub) ->
      channelsub.channelsubsocket.close())

exports.Subscriber = Subscriber