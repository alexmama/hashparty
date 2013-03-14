{Master} = require "../lib/master"
{Slave} = require "../lib/slave"
{Publisher} = require "../lib/publisher"
{Channel} = require "../lib/channel"
{Subscriber} = require "../lib/subscriber"

main = ->

  tracker = new Channel("TRACKER")
  ch1 = new Channel("CHONE")
  ch2 = new Channel("CHTWO")

  # Adding 3 instances of SUB1 and 2 instance of SUB2, registered on 2 different channels
  (new Subscriber "SONE", tracker).subscribe(ch1)
  (new Subscriber "SONE", tracker).subscribe(ch1)
  (new Subscriber "SONE", tracker).subscribe(ch2)
  (new Subscriber "STWO", tracker).subscribe(ch1)
  (new Subscriber "STWO", tracker).subscribe(ch2)

  publisher = new Publisher()
  publisher.addChannel(ch1)
  publisher.addChannel(ch2)

  msgCount = 11

  publisher.send "msg #{msgCount}" while msgCount -= 1

main()