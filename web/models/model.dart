library app;

@MirrorsUsed(targets: 'ModelProvider, Model, Name', override: '*')
import "dart:mirrors";

abstract class ModelProvider {
  Iterable<Model> getModels(Model m);
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
