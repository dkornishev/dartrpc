library remote_client;

import 'dart:html';
import "dart:mirrors";
import "dart:async";

import "transport.dart";

Map _requests = {};

WebSocket _ws;

runRemote(Type type, String uri) {

  if(_ws == null) {
    _ws = new WebSocket(uri);
    _ws.onMessage.listen((MessageEvent event) {
      ResponseEnvelope env = decode(event.data);

      Completer comp = _requests[env.inResponseTo];
      _requests.remove(env.inResponseTo);
      comp.complete(env.payload);
    });
  }

  return new _DynamicProxy(type, uri);
}

/**
 * Dynamic proxy that delegates execution to the server
 * via web sockets
 */
class _DynamicProxy {
  Type _type;
  String _uri;

  _DynamicProxy(this._type, this._uri);

  /**
   *  Transparently proxies calls to the server
   *  via websockets
   */
  noSuchMethod(Invocation inv) {
    var sw = new Stopwatch();
    sw.start();
    var library = reflectClass(_type).owner.simpleName;
    var typeName = reflectClass(_type).simpleName;

    var completer = new Completer();

    var sendRequest = () {
      InvocationDTO command = new InvocationDTO();

      command.owner = library;
      command.type = typeName;
      command.function = inv.memberName;
      command.positionalParams = inv.positionalArguments;
      command.namedParams = inv.namedArguments;

      _ws.send(encode(command));

      _requests[command.requestId] = completer;
      sw.stop();

      print("SEND ENDED IN: ${sw.elapsedMilliseconds}");
    };

    if(_ws.readyState == WebSocket.OPEN) {
      sendRequest();
    } else {
      _ws.onOpen.listen((_) {
        sendRequest();
      });
    }

    return completer.future;
  }
}

