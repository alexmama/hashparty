hashparty = require "../lib/hashparty"

main = ->

  ch1 = null
  ch2 = null
  ch3 = null
  publisher = null
  sub1_1 = null
  sub1_2 = null
  sub1_3 = null
  sub2_1 = null
  sub2_2 = null
  sub2_3 = null

  tracker = new hashparty.Channel("TRACKER")

  setTimeout( =>
    # Creating two clones (ch1, ch2) of the same logical channel (CHAN) and another one completely different (ch3, NACH)
    ch1 = new hashparty.Channel("CHAN", tracker)
    ch2 = new hashparty.Channel("CHAN", tracker)
    ch3 = new hashparty.Channel("NACH", tracker)

    # subscribing 3 clones of SONE to redundant instances of CHONE
    sub1_1 = new hashparty.Subscriber "SONE", tracker
    sub1_1.subscribe(ch1)
    sub1_2 = new hashparty.Subscriber "SONE", tracker
    sub1_2.subscribe(ch1)
    sub1_3 = new hashparty.Subscriber "SONE", tracker
    sub1_3.subscribe(ch2)
    # Adding one instance of STWO to each channel instance
    sub2_1 = new hashparty.Subscriber "STWO", tracker
    sub2_1.subscribe(ch1)
    sub2_2 = new hashparty.Subscriber "STWO", tracker
    sub2_2.subscribe(ch2)
    sub2_3 = new hashparty.Subscriber "STWO", tracker
    sub2_3.subscribe(ch3)

    publisher = new hashparty.Publisher("PUB")
    publisher.addChannel(ch1)
    publisher.addChannel(ch2)
    publisher.addChannel(ch3)
  , 100)

  # Waiting 100ms before pulling the trigger
  setTimeout(=>
    msgCount = 10001
    publisher.send "msg #{msgCount}" while msgCount -= 1
  , 1000)

  setTimeout(=>
    #cleaning
    sub1_1.clean()
    sub1_2.clean()
    sub1_3.clean()
    sub2_1.clean()
    sub2_2.clean()
    sub2_3.clean()
    publisher.clean()
    ch1.clean()
    ch2.clean()
    ch3.clean()
    tracker.clean()
  ,10000)

main()