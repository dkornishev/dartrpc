library app_client;

import 'dart:html';
import 'dart:async';

import '../../lib/remote_client.dart';
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
    service = runRemote(ModelProvider, "ws://127.0.0.1:8080/models");
  }

  var model = new Model()
  ..name = new Name.newInstance("Оксана", "Сергеевна", "Баюл")
  ..bust = 85.1
  ..waist = 62
  ..hips = 85.1;

  service.getModels(model).then((data) {
    sw.stop();
    querySelector("#sample_text_id").text = "${data.toString()} >> ${sw.elapsedMilliseconds.toString()}\n";
  });
}
