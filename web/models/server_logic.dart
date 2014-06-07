library model_server;

import 'model.dart';

class TestCarProvider implements CarProvider {

  Iterable<Car> getCars(Car car) {
    var car1 = new Car();
    car1.color = "red";
    car1.name = new Name.newInstance("Toyota", "Camry", 2002);
    car1.vin = "ZZZZPPPP";

    var car2 = new Car();
    car2.color = "blue";
    car2.name = new Name.newInstance("Lada", "Kalina", 2002);
    car2.vin = "UUUUUUUUo";

    return [car1, car2, car];
  }
}