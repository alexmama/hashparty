{Master} = require "../lib/master"
{Slave} = require "../lib/slave"
{Publisher} = require "../lib/publisher"
{Channel} = require "../lib/channel"
{Subscriber} = require "../lib/subscriber"

main = ->

  channel = new Channel("CH1")
  # Adding 2 instances of SUB1 and one instance of SUB2
  (new Subscriber "SUB1").subscribe(channel)
  (new Subscriber "SUB1").subscribe(channel)
  (new Subscriber "SUB2").subscribe(channel)

  publisher = new Publisher()
  publisher.addChannel(channel)

  msgCount = 21

  publisher.send "msg #{msgCount}" while msgCount -= 1

main()