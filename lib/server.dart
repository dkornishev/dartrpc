library object_proxy_server;

import "dart:mirrors";

import "transport.dart";

Map _handlers = {};

process(data) {

    InvocationDTO dto = decode(data);

    ClassMirror cm = currentMirrorSystem().findLibrary(dto.owner).declarations[dto.type];

    if(!_handlers.containsKey(cm.simpleName)) {
     _handlers[cm.simpleName] = cm.newInstance(new Symbol(""), []);
    }

    InstanceMirror im = _handlers[cm.simpleName];

    var resp = im.invoke(dto.function, dto.positionalParams, dto.namedParams);

    return encode(new ResponseEnvelope.newInstance(dto.requestId, resp.reflectee));
}