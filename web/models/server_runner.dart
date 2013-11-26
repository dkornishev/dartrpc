
import '../../lib/transport.dart';
import "package:dartrs/dartrs.dart";
import 'model.dart';

void main() {
  RestfulServer.bind().then((server) {
    server
      ..isolates = 16
      ..isolateInit = new ModelInit();
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