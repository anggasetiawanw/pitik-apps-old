import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmDayHistory {
  int? id;
  String? coopId;
  int? day;
  String? date;
  double? estimatedPopulation;
  double? fcr;
  double? abw;
  double? mortality;
  double? feedConsumption;

  FarmDayHistory({this.id, this.coopId, this.day, this.date, this.estimatedPopulation, this.fcr, this.abw, this.mortality, this.feedConsumption});

  static FarmDayHistory toResponseModel(Map<String, dynamic> map) {
    return FarmDayHistory(
        id: map['id'],
        coopId: map['coopId'],
        day: map['day'],
        date: map['date'],
        estimatedPopulation: map['estimatedPopulation'] != null ? map['estimatedPopulation'].toDouble() : map['estimatedPopulation'],
        fcr: map['fcr'] != null ? map['fcr'].toDouble() : map['fcr'],
        abw: map['abw'] != null ? map['abw'].toDouble() : map['abw'],
        mortality: map['mortality'] != null ? map['mortality'].toDouble() : map['mortality'],
        feedConsumption: map['feedConsumption'] != null ? map['feedConsumption'].toDouble() : map['feedConsumption']);
  }
}
