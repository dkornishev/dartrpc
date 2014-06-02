library model_server;

import 'model.dart';

class TestModelProvider implements ModelProvider {
  Iterable<Model> getModels(Model m) {

    var oksana = new Model()
      ..name = new Name.newInstance("Oksana", "", "Fedorova")
      ..bust = 90.1
      ..waist = 60
      ..hips = 90.1;

    var anna = new Model()
      ..name = new Name.newInstance("Anna", "", "Kurnikova")
      ..bust = 80.1
      ..waist = 50
      ..hips = 80.1;

    return [anna, oksana, m];
  }
}