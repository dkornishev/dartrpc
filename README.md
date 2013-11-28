Introduction
============
Framework to transparently run code on the server via client-side proxies over web sockets

Given the methodology of "same language on server and client", it is my belief that it should be
possible to interact with server-side code using regular language constructs (method invocations).

Dartrpc aims to accomplish this goal.

Usage
=====
While no efforts were spared to minimize need for boiler-plate, limitations of dart language
got in the way of completely boiler-plate free implementation

Domain and Service
------------------
Create domain and service classes as you normally would

You MUST add mirrors import with @MirrorsUsed annotation listing all your domain and service classes
certain optimizations had to be applied which strips mirrored access of everything not explictely 
stated in such annotations (see: https://code.google.com/p/dart/issues/detail?id=15344)
```dart
@MirrorsUsed(targets: '<your service>, <domain class 1>, <domain class 2> ...', override: '*')
import "dart:mirrors";
```

Server
------
Create a server with a web socket endpoint that invokes 'process' library function.  

Example below uses dartrs:
```dart
library server_example;

import "package:dartrs/dartrs.dart";
import 'package:dartrpc/transport.dart';
import '<your doman and service classes>.dart'; //  dart doesn't "context scan/load all from dir"

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
```

Client
------
Use runRemote to create a proxy on service objects and then make calls as you normally would.
Note the proxy object returns Futures for all invocations.

```dart
import 'package:dartrpc/remote_client.dart';

var service = runRemote(ModelProvider, "ws://127.0.0.1:8080/models");
service.getModels().then((response) {
  //... do something with response
});
```

Example
=======
See web/models

Performance
===========
Quite acceptable, and hopefully will continue to improve as dart and dart2js is improved
On my machine, provided example takes between 16 and ~50 ms.

Framework Integration
=====================
The intent was to figure out a way to integrate such proxying with Angular-dart and Polymer.
Sadly, both rely heavily on mirrors and don't seem to provide a facility of "here's the domain object
but uses this other instance when you need to make calls".

If anybody has any ideas on how this might be accomplished, it would be greatly apreciated.