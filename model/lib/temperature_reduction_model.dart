// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class TemperatureReduction {
  String? group;
  int? day;
  double? reduction;

  TemperatureReduction({this.group, this.day, this.reduction});

  static TemperatureReduction toResponseModel(Map<String, dynamic> map) {
    if (map['reduction'] is int) {
      map['reduction'] = map['reduction'].toDouble();
    }

    return TemperatureReduction(group: map['group'].toString(), day: map['day'], reduction: map['reduction']);
  }
}
