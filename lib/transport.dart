library remote_shared;

import "dart:mirrors";
import "dart:convert";
import 'package:serialization/serialization.dart';

Serialization _ser;
Map _handlers = {};

String encode(object) {
  _init();

  return JSON.encode(_ser.write(object));
}

Object decode(input) {
  _init();

  return _ser.read(JSON.decode(input));
}

process(data) {

    InvocationDTO dto = decode(data);

    var now = new DateTime.now().millisecondsSinceEpoch;

    ClassMirror cm = currentMirrorSystem().findLibrary(dto.owner).declarations[dto.type];

    if(!_handlers.containsKey(cm.simpleName)) {
     _handlers[cm.simpleName] = cm.newInstance(new Symbol(""), []);
    }

    InstanceMirror im = _handlers[cm.simpleName];

    var resp = im.invoke(dto.function, dto.positionalParams, dto.namedParams);

    return encode(new ResponseEnvelope.newInstance(dto.requestId, resp.reflectee));
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

  InvocationDTO() {
    requestId = new DateTime.now().millisecondsSinceEpoch;
  }

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