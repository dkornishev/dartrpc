library server_example;

import '../../lib/transport.dart';
import "package:dartrs/dartrs.dart";
import 'model.dart';

void main() {
  RestfulServer.bind(init: new ModelInit(), concurrency:8).then((server) {
 
  });
}

class ModelInit {
  call(RestfulServer server) {
    server
      ..onWs("/models", (data) {
        return process(data);
      });
  }
}