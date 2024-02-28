// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class DeviceSummaryDashboard {
  String? id;
  String? coopCodeId;
  String? deviceId;
  double? temperature;
  double? humidity;

  DeviceSummaryDashboard({this.temperature, this.id, this.coopCodeId, this.humidity, this.deviceId});

  static DeviceSummaryDashboard toResponseModel(Map<String, dynamic> map) {
    if (map['temperature'] is int) {
      map['temperature'] = map['temperature'].toDouble();
    }
    if (map['humidity'] is int) {
      map['humidity'] = map['humidity'].toDouble();
    }

    return DeviceSummaryDashboard(
      id: map['id'],
      coopCodeId: map['coopCodeId'],
      humidity: map['humidity'],
      temperature: map['temperature'],
      deviceId: map['deviceId'],
    );
  }
}
