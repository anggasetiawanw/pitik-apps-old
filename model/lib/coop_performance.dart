import 'package:model/coop_active_standard.dart';
import 'consumption.dart';
import 'engine_library.dart';
import 'population.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class CoopPerformance {
  String? farmingCycleId;
  String? taskTicketId;
  String? date;
  int? day;

  @IsChild()
  CoopActiveStandard? bw;

  @IsChild()
  CoopActiveStandard? adg;

  @IsChild()
  CoopActiveStandard? ip;

  @IsChild()
  CoopActiveStandard? fcr;

  @IsChild()
  CoopActiveStandard? mortality;

  @IsChild()
  CoopActiveStandard? hdp;

  @IsChild()
  CoopActiveStandard? eggMass;

  @IsChild()
  CoopActiveStandard? eggWeight;

  @IsChild()
  CoopActiveStandard? feedIntake;

  @IsChild()
  Population? population;

  @IsChild()
  Consumption? feed;

  @IsChild()
  Consumption? ovk;

  CoopPerformance({this.farmingCycleId, this.taskTicketId, this.date, this.day, this.bw, this.adg, this.ip, this.fcr, this.mortality, this.hdp, this.eggMass, this.eggWeight, this.feedIntake, this.population, this.feed, this.ovk});

  static CoopPerformance toResponseModel(Map<String, dynamic> map) {
    return CoopPerformance(
      farmingCycleId: map['farmingCycleId'],
      taskTicketId: map['taskTicketId'],
      date: map['date'],
      day: map['day'],
      bw: Mapper.child<CoopActiveStandard>(map['bw']),
      adg: Mapper.child<CoopActiveStandard>(map['adg']),
      ip: Mapper.child<CoopActiveStandard>(map['ip']),
      fcr: Mapper.child<CoopActiveStandard>(map['fcr']),
      mortality: Mapper.child<CoopActiveStandard>(map['mortality']),
      hdp: Mapper.child<CoopActiveStandard>(map['hdp']),
      eggMass: Mapper.child<CoopActiveStandard>(map['eggMass']),
      eggWeight: Mapper.child<CoopActiveStandard>(map['eggWeight']),
      feedIntake: Mapper.child<CoopActiveStandard>(map['feedIntake']),
      population: Mapper.child<Population>(map['population']),
      feed: Mapper.child<Consumption>(map['feed']),
      ovk: Mapper.child<Consumption>(map['ovk']),
    );
  }
}
