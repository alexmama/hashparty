_ = require "underscore"
_s = require "underscore.string"
{EventEmitter2} = require "eventemitter2"
zmq = require "zmq"

UUID = ->
UUID.generate = ->
  a = UUID._gri
  b = UUID._ha
  b(a(32), 8) + "-" + b(a(16), 4) + "-" + b(16384 | a(12), 4) + "-" + b(32768 | a(14), 4) + "-" + b(a(48), 12)

UUID._gri = (a) ->
  (if 0 > a then NaN else (if 30 >= a then 0 | Math.random() * (1 << a) else (if 53 >= a then (0 | 1073741824 * Math.random()) + 1073741824 * (0 | Math.random() * (1 << a - 30)) else NaN)))

UUID._ha = (a, b) ->
  c = a.toString(16)
  d = b - c.length
  e = "0"

  while 0 < d
    d & 1 and (c = e + c)
    d >>>= 1
    e += e
  c

class Peer extends EventEmitter2

  barename: undefined
  fullname: undefined
  friends: undefined
  tracker_insocket: undefined
  tracker_outsocket: undefined

  constructor: (p_barename, p_tracker) ->
    super(wildcard: true, verbose: true)
    @barename = p_barename
    @fullname = "#{@barename}.#{UUID.generate()}"
    @friends = []
    @friends.push @fullname
    if p_tracker
      # Connecting to tracker
      @tracker_insocket = zmq.socket "pub"
      @tracker_insocket.connect p_tracker.in_endpoint
      @tracker_outsocket = zmq.socket "sub"
      @tracker_outsocket.connect p_tracker.out_endpoint
      @tracker_outsocket.on "message", (p_message) =>
        #console.log "message from tracker: '#{p_message}'"
        parts = _s.words(p_message, "::")
        type = parts[0]
        publisher = parts[1]
        payload = JSON.parse parts[2]
        payload.publisher = publisher
        @emit "#{type}::#{publisher}", payload

      # Enabling peer discovery
      @tracker_outsocket.subscribe("peerstate::#{@barename}") # subscribe to status of my friends (same barename)
      @on "peerstate::#{@barename}.*", (p_peerstatus) =>
        # TODO: check that it is really a peer status
        # a peer has come, but maybe it is myself or it is not the first time I see it
        if not _.contains(@friends, p_peerstatus.publisher)
          # it is the first time and it is not me, we will reference it...
          @addFriend(p_peerstatus.publisher)
          #...then I reply him, and all others (including myself), with my own status
          # TODO: reply using a single direct connection rather than broadcast)
          @sendStateToTracker()

      ## Initiating discovery
      setTimeout( # waiting for 50 millis before starting discovery
        # now will send my state to initiate discovery
        => @sendStateToTracker()
      ,50)

  bareFromFull: (p_fullname) ->
    _s.strLeft(p_fullname, ".")

  sendStateToTracker: ->
    if @tracker_insocket
      @tracker_insocket.send "peerstate::#{@fullname}::#{JSON.stringify(status: "ready")}"

  addFriend: (p_fullname) ->
    console.log "'#{@fullname}' discovered a clone '#{p_fullname}'"
    @friends.push p_fullname

  clean: ->
    @tracker_insocket.close() if @tracker_insocket
    @tracker_outsocket.close() if @tracker_outsocket

exports.Peer = Peer

