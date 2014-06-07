library app_client;

import 'dart:html';
import 'dart:async';

import '../../lib/rpc_client.dart';
import 'model.dart';

var service;
void main() {
  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(loadModels);
}

void loadModels(MouseEvent event) {
  Stopwatch sw = new Stopwatch();

  sw.start();
  if(service == null)  {
    service = runRemote(CarProvider, "ws://127.0.0.1:8080/rpc");
  }

  var car1 = new Car();
  car1.color = "white";
  car1.name = new Name.newInstance("Honda", "Accord", 2012);
  car1.vin = "eeeeeeeee";


  service.getCars(car1).then((data) {
    sw.stop();
    querySelector("#sample_text_id").text = "${data.toString()} >> ${sw.elapsedMilliseconds.toString()}\n";
  });
}
