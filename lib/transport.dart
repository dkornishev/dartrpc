library remote_shared;

import "dart:mirrors";
import "dart:convert";
import 'package:log4dart/log4dart.dart';
import 'package:serialization/serialization.dart';
import 'package:uuid/uuid.dart';

Logger _log = LoggerFactory.getLogger("remote_shared");

Uuid _uuid = new Uuid();
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
  String requestId;
  Symbol owner;
  Symbol type;
  Symbol function;
  List positionalParams = [];
  Map namedParams = {};

  InvocationDTO() {
    requestId = _uuid.v1();
  }

  InvocationDTO.newInstance(this.owner, this.type, this.function, this.positionalParams, this.namedParams) {
    requestId = _uuid.v1();
  }
}

class ResponseEnvelope {
  String inResponseTo;
  Object payload;

  ResponseEnvelope();

  ResponseEnvelope.newInstance(this.inResponseTo, this.payload);
}