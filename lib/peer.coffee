_ = require "underscore"
{EventEmitter2} = require "eventemitter2"

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
  tracker: undefined

  constructor: (p_barename, p_tracker) ->
    super(wildcard: true, verbose: true)
    @barename = p_barename
    @fullname = "#{@barename}.#{UUID.generate()}"
    @friends = []
    @friends.push @fullname
    if p_tracker
      @tracker = p_tracker
      @discoverFriends()

  discoverFriends: ->
    # registering any peer that may appear
    # TODO: use specialized multicast discovery channel for this purpose)
    @tracker.on "state.#{@barename}.*", (p_peerstatus) =>
      # a peer has come, but maybe it is myself or it is not the first time I see it
      if not _.contains(@friends, p_peerstatus.full)
        # it is the first time and it is not me, we will reference it...
        @addFriend(p_peerstatus.full)
        #...then I reply him, and all others (including myself), with my own status
        # TODO: reply using a single direct connection rather than broadcast)
        @tracker.emit("state.#{@fullname}", full: @fullname)

    # now first advertise peers that it comes, i should normally receive a copy
    # TODO: use specialized multicast discovery channel for this purpose)
    @tracker.emit("state.#{@fullname}", full: @fullname)

  addFriend: (p_fullname) ->
    console.log "'#{@fullname}' discovered a clone '#{p_fullname}'"
    @friends.push p_fullname

exports.Peer = Peer

