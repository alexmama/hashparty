// Generated by CoffeeScript 1.6.1
(function() {
  var hashparty, main;

  hashparty = require("../lib/hashparty");

  main = function() {
    var master, msgCount, _results;
    master = new hashparty.Master();
    master.addWorker(new hashparty.Slave("S1"));
    master.addWorker(new hashparty.Slave("S2"));
    master.addWorker(new hashparty.Slave("S3"));
    msgCount = 11;
    _results = [];
    while (msgCount -= 1) {
      _results.push(master.send("msg " + msgCount));
    }
    return _results;
  };

  main();

}).call(this);
