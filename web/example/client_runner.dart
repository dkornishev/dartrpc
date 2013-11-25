import 'dart:html';

import '../../lib/objectproxy.dart';
import "model.dart";
import 'dart:async';

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
    service = proxify(ModelProvider);
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
