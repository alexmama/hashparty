_ = require "underscore"
async = require "async"

class Channel

  # @property {string}
  id: undefined
  # @property {Object}
  subscribers: undefined

  constructor: (p_id) ->
    @id = p_id
    @subscribers = []

  addSubscriber: (newsub) ->
    _.each(
            @subscribers,
          (sub) ->
            # reference subscribers manually
            if sub.barename is newsub.barename
              sub.addFriend newsub.fullname
              newsub.addFriend sub.fullname
          )
    @subscribers.push newsub

  publish: (msg) ->
    # republishing every message to subcribers
    @send(msg)

  send: (msg) ->

    # sending the message to every subscribers (async mode)
    async.each(
        @subscribers,
      (sub) =>
        sub.onMessage(msg)
        (err) ->
          # do nothing
      )

exports.Channel = Channel