HashRing = require "hashring"
_ = require "underscore"

class Master

  # @property {Object}
  ring: undefined
  workers: undefined

  constructor: ->
    @ring = new HashRing()
    @workers = []

  addWorker: (worker) ->
    @ring.add worker.id
    @workers.push worker

  send: (msg) ->
    # use consistent hashing to identify the worker
    workerID = @ring.get msg
    # get the matching worker from the list
    worker = _.find(
            @workers,
            (w) ->
              w.id is workerID
    )
    # sending the message
    worker.onMessage msg

exports.Master = Master