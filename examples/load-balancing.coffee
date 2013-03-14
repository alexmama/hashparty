hashparty = require "../lib/hashparty"

main = ->

  master = new hashparty.Master()
  master.addWorker( new hashparty.Slave("S1") )
  master.addWorker( new hashparty.Slave("S2") )
  master.addWorker( new hashparty.Slave("S3") )

  msgCount = 11

  master.send "msg #{msgCount}" while msgCount -= 1

main()