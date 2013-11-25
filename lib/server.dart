library object_proxy_server;

import 'dart:io';
import "dart:mirrors";
import "dart:isolate";
import "dart:async";

import "dto.dart";

List _connections = [];
Map _handlers = {};

void startServer() {
  HttpServer.bind("127.0.0.1", 8080).then((server) {
    print("Server started...");
    server.listen((HttpRequest request) {
      if(WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then((sws) {
          _connections.add(sws);

          SendPort sp;
          ReceivePort rp = new ReceivePort();
          Isolate.spawn(wsRunner, rp.sendPort).then((iss) {
            rp.listen((data) {
              if(data is SendPort) {
                sp = data;
                sws.listen((data) {
                  sp.send(data);
                });
              } else {
                sws.add(data);
              }
            });
          });
        });
      }
    });
  });
}

void wsRunner(SendPort sp) {
  ReceivePort rp = new ReceivePort();

  sp.send(rp.sendPort);

  rp.listen((data) {
    InvocationDTO dto = decode(data);

    ClassMirror cm = currentMirrorSystem().findLibrary(dto.owner).declarations[dto.type];

    if(!_handlers.containsKey(cm.simpleName)) {
     _handlers[cm.simpleName] = cm.newInstance(new Symbol(""), []);
    }

    InstanceMirror im = _handlers[cm.simpleName];

    var resp = im.invoke(dto.function, dto.positionalParams, dto.namedParams);

    sp.send(encode(new ResponseEnvelope.newInstance(dto.requestId, resp.reflectee)));
  });
}
