import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmActualTarget {
  double? max;
  double? min;

  FarmActualTarget({this.max, this.min});

  static FarmActualTarget toResponseModel(Map<String, dynamic> map) {
    return FarmActualTarget(max: map['max'] != null ? map['max'].toDouble() : map['max'], min: map['min'] != null ? map['min'].toDouble() : map['min']);
  }
}
