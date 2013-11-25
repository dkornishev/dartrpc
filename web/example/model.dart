library app;

class ModelProvider {
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

class Model {
  Name name;

  double bust;
  int waist;
  double hips;

  String toString() {
    return "$name $bust-$waist-$hips";
  }
}

class Name {
  String first;
  String middle;
  String last;

  Name() {

  }

  Name.newInstance(this.first, this.middle, this.last);

  String toString() {
    return "$last, $first $middle";
  }
}
