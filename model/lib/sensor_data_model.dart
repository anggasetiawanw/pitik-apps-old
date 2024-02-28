// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class SensorData {
  double? value;
  String? uom;
  String? status;

  SensorData({this.value, this.uom, this.status});

  static SensorData toResponseModel(Map<String, dynamic> map) {
    if (map['value'] is int) {
      map['value'] = map['value'].toDouble();
    }

    return SensorData(
      value: map['value'],
      uom: map['uom'],
      status: map['status'],
    );
  }
}
