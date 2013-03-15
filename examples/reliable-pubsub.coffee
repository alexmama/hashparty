hashparty = require "../lib/hashparty"

main = ->

  tracker = new hashparty.Channel("TRACKER")

  # Creating two clones (ch1, ch2) of the same logical channel (CHAN) and another one completely different (ch3, NACH)
  ch1 = new hashparty.Channel("CHAN", tracker)
  ch2 = new hashparty.Channel("CHAN", tracker)
  ch3 = new hashparty.Channel("NACH", tracker)

  # subscribing 3 clones of SONE to redundant instances of CHONE
  (new hashparty.Subscriber "SONE", tracker).subscribe(ch1)
  (new hashparty.Subscriber "SONE", tracker).subscribe(ch1)
  (new hashparty.Subscriber "SONE", tracker).subscribe(ch2)
  # Adding one instance of STWO to each channel instance
  (new hashparty.Subscriber "STWO", tracker).subscribe(ch1)
  (new hashparty.Subscriber "STWO", tracker).subscribe(ch2)
  (new hashparty.Subscriber "STWO", tracker).subscribe(ch3)

  publisher = new hashparty.Publisher("PUB")
  publisher.addChannel(ch1)
  publisher.addChannel(ch2)
  publisher.addChannel(ch3)

  msgCount = 11

  publisher.send "msg #{msgCount}" while msgCount -= 1

main()