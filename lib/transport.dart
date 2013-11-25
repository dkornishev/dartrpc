library object_proxy_shared;

import "dart:convert";
import 'package:serialization/serialization.dart';

Serialization _ser;

String encode(object) {
  _init();

  return JSON.encode(_ser.write(object));
}

Object decode(input) {
  _init();

  return _ser.read(JSON.decode(input));
}

_init() {
  if(_ser == null) {
    _ser = new Serialization();
    _ser.addRuleFor(InvocationDTO);
    _ser.addRuleFor(ResponseEnvelope);
  }
}

class InvocationDTO {
  int requestId;
  Symbol owner;
  Symbol type;
  Symbol function;
  List positionalParams = [];
  Map namedParams = {};

  InvocationDTO();

  InvocationDTO.newInstance(this.owner, this.type, this.function, this.positionalParams, this.namedParams) {
    requestId = new DateTime.now().millisecondsSinceEpoch;
  }
}

class ResponseEnvelope {
  int inResponseTo;
  Object payload;

  ResponseEnvelope();

  ResponseEnvelope.newInstance(this.inResponseTo, this.payload);
}