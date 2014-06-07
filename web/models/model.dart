library app;

@MirrorsUsed(targets: 'CarProvider, Car, Name', override: '*')
import "dart:mirrors";

abstract class CarProvider {
  Iterable<Car> getCars(Car m);
}

class Car {
  Name name;

  String color;
  String vin;

  String toString() {
    return "$color $name\n $vin";
  }
}

class Name {
  String make;
  String model;
  int year;


  Name() {  }

  Name.newInstance(this.make, this.model, this.year);

  String toString() {
    return "$make $model $year";
  }
}
