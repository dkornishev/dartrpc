library remote_client;

@MirrorsUsed(targets: 'serialization, InvocationDTO, ResponseEnvelope', override: '*')
import "dart:mirrors";

import 'dart:html';
import "dart:async";

import "transport.dart";

Map _requests = {};

runRemote(Type type, String uri) {
  return new _DynamicProxy(type, uri);
}

/**
 * Dynamic proxy that delegates execution to the server
 * via web sockets
 */
class _DynamicProxy {
  Type _type;
  String _uri;
  WebSocket _ws;

  _DynamicProxy(this._type, this._uri) {
    _ws = new WebSocket(_uri);
    _ws.onMessage.listen((MessageEvent event) {
      ResponseEnvelope env = decode(event.data);

      Completer comp = _requests[env.inResponseTo];
      _requests.remove(env.inResponseTo);
      comp.complete(env.payload);
    });
  }

  /**
   *  Transparently proxies calls to the server
   *  via websockets
   */
  noSuchMethod(Invocation inv) {
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

