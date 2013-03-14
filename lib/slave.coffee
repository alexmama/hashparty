class Slave

  # @property {string}
  id: undefined
  # @property {Object}
  msgCount: undefined

  constructor: (p_id) ->
    @id = p_id
    @msgCount = 0

  onMessage: (message) ->

    console.log "#{@id} PROCESSING msg '#{message}'"
    @msgCount++

exports.Slave = Slave