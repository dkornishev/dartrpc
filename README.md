[![Build Status](https://drone.io/github.com/dkornishev/dartrpc/status.png)](https://drone.io/github.com/dkornishev/dartrpc/latest)
Introduction
============
Framework to transparently run code on the server via client-side proxies over web sockets

Dartrpc makes it possible to interact with server-side code using regular language constructs (method invocations).


Usage
=====
While no efforts were spared to minimize need for boiler-plate, limitations of dart language
got in the way of completely boiler-plate free implementation

Domain and Service
------------------
Create domain and service classes as you normally would

You MUST add mirrors import with @MirrorsUsed annotation listing all your domain and service classes
as certain optimizations had to be applied which strip mirrored access of everything not explicitely 
stated in such annotations (see: https://code.google.com/p/dart/issues/detail?id=15344)
Library did work without these annotations, but generated JS was > 5 mb
```dart
@MirrorsUsed(targets: '<your service>, <domain class 1>, <domain class 2> ...', override: '*')
import "dart:mirrors";
```

Server
------
Import model and provider classes.  Instantiate RPCServer

```dart
var server = new RPCServer();
```

Client
------
Use runRemote to create a proxy on service objects and then make calls as you normally would.
Note the proxy object returns Futures for all invocations.

```dart
import 'package:dartrpc/remote_client.dart';

var service = runRemote(CarProvider, "ws://127.0.0.1:8080/rpc");
service.getCars().then((response) {
  //... do something with response
});
```

Example
=======
See web/models

Performance
===========
On my machine after a few calls drops to 15-20 ms range.  Initial 2-3 calls are rather slow.

Framework Integration
=====================
The intent was to figure out a way to integrate such proxying with Angular-dart and Polymer.
Sadly, both rely heavily on mirrors and don't seem to provide a facility of "here's the domain object
but uses this other instance when you need to make calls".

If anybody has any ideas on how this might be accomplished, it would be greatly apreciated.
