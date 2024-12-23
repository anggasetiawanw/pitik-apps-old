// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import 'room_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class Sensor {
  String? id;
  String? name;
  String? position;
  String? deviceName;
  int? totalDevice;
  String? sensorCode;
  String? sensorMac;
  String? sensorType;
  double? temperature;
  double? humidity;
  int? status;
  String? roomId;
  int? recordCount;

  @IsChild()
  Room? room;

  Sensor({this.id, this.name, this.position, this.deviceName, this.totalDevice, this.temperature, this.humidity, this.sensorMac, this.sensorType, this.sensorCode, this.status, this.roomId, this.recordCount, this.room});

  static Sensor toResponseModel(Map<String, dynamic> map) {
    if (map['temperature'] is int) {
      map['temperature'] = map['temperature'].toDouble();
    }
    if (map['humidity'] is int) {
      map['humidity'] = map['humidity'].toDouble();
    }

    return Sensor(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      deviceName: map['deviceName'],
      totalDevice: map['totalDevice'],
      temperature: map['temperature'],
      sensorMac: map['sensorMac'],
      sensorType: map['sensorType'],
      humidity: map['humidity'],
      sensorCode: map['sensorCode'],
      status: map['status'],
      roomId: map['roomId'],
      recordCount: map['recordCount'],
      room: Mapper.child<Room>(map['room']),
    );
  }
}
