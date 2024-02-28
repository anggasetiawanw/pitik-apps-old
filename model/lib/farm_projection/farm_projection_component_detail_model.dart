import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmProjectionComponentDetail {
  int? dayNum;
  double? current;
  double? benchmark;

  FarmProjectionComponentDetail({this.dayNum, this.current, this.benchmark});

  static FarmProjectionComponentDetail toResponseModel(Map<String, dynamic> map) {
    return FarmProjectionComponentDetail(dayNum: map['dayNum'], current: map['current'] != null ? map['current'].toDouble() : map['current'], benchmark: map['benchmark'] != null ? map['benchmark'].toDouble() : map['benchmark']);
  }
}
