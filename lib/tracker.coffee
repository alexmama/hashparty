{Channel} = require "./channel"
_ = require "underscore"

class Tracker extends Channel

  peerGroups: undefined

  constructor: (p_barename) ->
    super (p_barename)
    @peerGroups = []

  getPeerGroupFromFull: (p_fullname) ->
    @getPeerGroupFromBare(@bareFromFull(p_fullname))

  getPeerGroupFromBare: (p_barename) ->
    @peerGroups[p_barename]

  setPeerStatus: (p_peerstatus) ->
    if not _.isObject(p_peerstatus) then throw "this is not a method"

    peerGroup = @getPeerGroupFromFull(p_peerstatus.fullname)
    if not _.isArray(peerGroup) then peerGroup = [] # the group does not exist, will create one
    peerGroup[p_peerstatus.fullname] = p_peerstatus

exports.Tracker = Tracker