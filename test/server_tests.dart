library remote_test;

import "../lib/transport.dart";
import "package:unittest/unittest.dart";

var ENCODED = '{"rules":{"rules":null,"data":[[],[[{"__Ref":0,"rule":8,"object":0},{"__Ref":0,"rule":6,"object":0},{"__Ref":0,"rule":9,"object":0},{"__Ref":0,"rule":7,"object":0},{"__Ref":0,"rule":14,"object":0},{"__Ref":0,"rule":15,"object":0},{"__Ref":0,"rule":10,"object":0},{"__Ref":0,"rule":10,"object":1},{"__Ref":0,"rule":10,"object":2}],[]],[[],[],["function","namedParams","owner","positionalParams","requestId","type"],[],[],["inResponseTo","payload"],[],[],["name","number"]],[],[],[],[[]],[[]],[[]],[[]],[[{"__Ref":0,"rule":1,"object":1},{"__Ref":0,"rule":2,"object":1},"",{"__Ref":0,"rule":2,"object":2},{"__Ref":0,"rule":12,"object":0}],[{"__Ref":0,"rule":1,"object":1},{"__Ref":0,"rule":2,"object":4},"",{"__Ref":0,"rule":2,"object":5},{"__Ref":0,"rule":12,"object":1}],[{"__Ref":0,"rule":1,"object":1},{"__Ref":0,"rule":2,"object":7},"",{"__Ref":0,"rule":2,"object":8},{"__Ref":0,"rule":12,"object":2}]],[],[["remote_shared.InvocationDTO"],["remote_shared.ResponseEnvelope"],["remote_test.Domain"]],[],[[]],[[]]],"roots":[{"__Ref":0,"rule":1,"object":0}]},"data":[[],[[{"__Ref":0,"rule":8,"object":0}]],[],[[{"__Ref":0,"rule":4,"object":3},{"__Ref":0,"rule":8,"object":0}]],[["scanDomain"],["remote_test"],["Service"],["pd"]],[],[[{"__Ref":0,"rule":4,"object":0},{"__Ref":0,"rule":3,"object":0},{"__Ref":0,"rule":4,"object":1},{"__Ref":0,"rule":1,"object":0},"8d158bd0-3ef0-11e3-8e64-f58579f2b2ba",{"__Ref":0,"rule":4,"object":2}]],[],[["domain2",10]]],"roots":[{"__Ref":0,"rule":6,"object":0}]}';

void main() {
  group("Process: ", () {
    test("Positive Test", () {
      var result = process(ENCODED);
      ResponseEnvelope re = decode(result);

      expect(re.payload is List, isTrue);
      expect(re.payload.length, equals(2));
      expect(re.payload[0] is Domain, isTrue);
    });
  });


}

getDomain() {
  var domain = new Domain()
  ..name = "domain2"
  ..number = 10;

  InvocationDTO dto = new InvocationDTO()
  ..owner = new Symbol("remote_test")
  ..type = new Symbol("Service")
  ..function = new Symbol("scanDomain")
  ..positionalParams = [domain]
  ..namedParams = {new Symbol("pd") : domain};

  return dto;
}


class Domain {
  String name;
  int number;
}

class Service {
  scanDomain(domain, {pd}) {
    var domain = new Domain()
      ..name = "domain"
      ..number = 10;

    return [domain, pd];
  }
}