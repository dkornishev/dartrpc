library rpc_server;

import 'package:dartrs/dartrs.dart';
import 'transport.dart';

/**
 * An RPC server using dartrs
 */
class RPCServer {
  var httpServer;

  RPCServer() {
    RestfulServer.bind(init: new _Init(), concurrency:8).then((server) {
      httpServer = server;
    });
  }

  Future shutdown() {
    return httpServer.close();
  }
}

class _Init {
  call(RestfulServer server) {
    server.onWs("/rpc", (data) {
      return process(data);
    });
  }
}