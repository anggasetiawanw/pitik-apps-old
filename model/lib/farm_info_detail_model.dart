import 'package:engine/dao/annotation/attribute.dart';
import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmInfoDetail {
  @Attribute(name: "coopId", primaryKey: true, notNull: true)
  String? coopId;

  @Attribute(name: 'farmingCycleStartDate')
  String? farmingCycleStartDate;

  @Attribute(name: "initialPopulation", type: "INTEGER", length: 10)
  int? initialPopulation;

  @Attribute(name: "day", type: "INTEGER", length: 3)
  int? day;

  @Attribute(name: "estimatedPopulation", type: "INTEGER", length: 10)
  int? estimatedPopulation;

  @Attribute(name: "mortality", type: "INTEGER", length: 10)
  int? mortality;

  @Attribute(name: "culled", type: "INTEGER", length: 10)
  int? culled;

  @Attribute(name: "harvested", type: "INTEGER", length: 10)
  int? harvested;

  @Attribute(name: "deadChick", type: "INTEGER", length: 10)
  int? deadChick;

  FarmInfoDetail({this.coopId, this.farmingCycleStartDate, this.initialPopulation, this.day, this.estimatedPopulation, this.mortality, this.culled, this.harvested, this.deadChick});

  static FarmInfoDetail toResponseModel(Map<String, dynamic> map) {
    return FarmInfoDetail(
        coopId: map['coopId'],
        farmingCycleStartDate: map['farmingCycleStartDate'],
        initialPopulation: map['initialPopulation'],
        day: map['day'],
        estimatedPopulation: map['estimatedPopulation'],
        mortality: map['mortality'],
        culled: map['culled'],
        harvested: map['harvested'],
        deadChick: map['deadChick']);
  }
}
