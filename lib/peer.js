// Generated by CoffeeScript 1.6.1
(function() {
  var EventEmitter2, Peer, UUID,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  EventEmitter2 = require("eventemitter2").EventEmitter2;

  UUID = function() {};

  UUID.generate = function() {
    var a, b;
    a = UUID._gri;
    b = UUID._ha;
    return b(a(32), 8) + "-" + b(a(16), 4) + "-" + b(16384 | a(12), 4) + "-" + b(32768 | a(14), 4) + "-" + b(a(48), 12);
  };

  UUID._gri = function(a) {
    if (0 > a) {
      return NaN;
    } else {
      if (30 >= a) {
        return 0 | Math.random() * (1 << a);
      } else {
        if (53 >= a) {
          return (0 | 1073741824 * Math.random()) + 1073741824 * (0 | Math.random() * (1 << a - 30));
        } else {
          return NaN;
        }
      }
    }
  };

  UUID._ha = function(a, b) {
    var c, d, e;
    c = a.toString(16);
    d = b - c.length;
    e = "0";
    while (0 < d) {
      d & 1 && (c = e + c);
      d >>>= 1;
      e += e;
    }
    return c;
  };

  Peer = (function(_super) {

    __extends(Peer, _super);

    Peer.prototype.barename = void 0;

    Peer.prototype.fullname = void 0;

    function Peer(p_barename) {
      Peer.__super__.constructor.call(this, {
        wildcard: true
      });
      this.barename = p_barename;
      this.fullname = this.barename + "." + UUID.generate();
    }

    return Peer;

  })(EventEmitter2);

  exports.Peer = Peer;

}).call(this);