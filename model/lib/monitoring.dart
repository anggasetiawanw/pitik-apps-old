import 'consumption.dart';
import 'coop_performance.dart';
import 'engine_library.dart';
import 'population.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Monitoring {
  int? day;
  int? chickenAge;
  String? coopName;
  int? period;
  int? currentTemperature;
  double? averageChickenAge;
  String? chickInDate;

  @IsChild()
  CoopPerformance? performance;

  @IsChild()
  Population? population;

  @IsChild()
  Consumption? feed;

  Monitoring({this.day, this.chickenAge, this.coopName, this.period, this.currentTemperature, this.averageChickenAge, this.chickInDate, this.performance, this.population, this.feed});

  static Monitoring toResponseModel(Map<String, dynamic> map) {
    return Monitoring(
      day: map['day'],
      chickenAge: map['chickenAge'],
      coopName: map['coopName'],
      period: map['period'],
      currentTemperature: map['currentTemperature'],
      averageChickenAge: map['averageChickenAge'] != null ? map['averageChickenAge'].toDouble() : map['averageChickenAge'],
      chickInDate: map['chickInDate'],
      performance: Mapper.child<CoopPerformance>(map['performance']),
      population: Mapper.child<Population>(map['population']),
      feed: Mapper.child<Consumption>(map['feed']),
    );
  }
}
