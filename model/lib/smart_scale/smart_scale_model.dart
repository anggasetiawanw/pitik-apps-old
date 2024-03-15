// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import '../room_model.dart';
import 'smart_scale_record_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupEntity
@SetupModel
@Table("t_smart_scale")
//SCALE TEAR OFF
class SmartScale {
// class SmartScale extends Offline {
  @Attribute(name: "id", type: "VARCHAR", length: 100, notNull: true)
  String? id;

  @Attribute(name: "farmingCycleId", type: "VARCHAR", length: 200, notNull: true)
  String? farmingCycleId;

  @Attribute(name: "day", type: "INTEGER", length: 10, defaultValue: "0")
  int? day;

  @Attribute(name: "totalCount", type: "INTEGER", length: 10, defaultValue: "0")
  int? totalCount;

  @Attribute(name: "averageWeight", type: "REAL", length: 10, defaultValue: "0")
  double? averageWeight;

  @Attribute(name: "avgWeight", type: "REAL", length: 10, defaultValue: "0")
  double? avgWeight;

  @Attribute(name: "roomId", type: "VARCHAR", length: 100, notNull: true)
  String? roomId;

  @IsChild()
  Room? room;

  @Attribute(name: "records", type: "VARCHAR", length: 1000)
  @IsChildren()
  List<SmartScaleRecord?> records;

  @Attribute(name: "details", type: "VARCHAR", length: 1000)
  @IsChildren()
  List<SmartScaleRecord?> details;

  @Attribute(name: "date", type: "VARCHAR", length: 100)
  String? date;

  @Attribute(name: "startDate", type: "VARCHAR", length: 100)
  String? startDate;

  @Attribute(name: "executionDate", type: "VARCHAR", length: 100)
  String? executionDate;

  @Attribute(name: "createdDate", type: "VARCHAR", length: 100)
  String? createdDate;

  @Attribute(name: "updatedDate", type: "VARCHAR", length: 100)
  String? updatedDate;

  SmartScale(
      {this.id,
      this.farmingCycleId,
      this.day,
      this.totalCount,
      this.averageWeight,
      this.avgWeight,
      this.roomId,
      this.room,
      this.records = const [],
      this.details = const [],
      this.date,
      this.startDate,
      this.executionDate,
      this.createdDate,
      this.updatedDate});

  static SmartScale toResponseModel(Map<String, dynamic> map) {
    return SmartScale(
        id: map['id'],
        farmingCycleId: map['farmingCycleId'],
        day: map['day'],
        totalCount: map['totalCount'],
        averageWeight: map['averageWeight'] != null ? map['averageWeight'].toDouble() : map['averageWeight'],
        avgWeight: map['avgWeight'] != null ? map['avgWeight'].toDouble() : map['avgWeight'],
        roomId: map['roomId'],
        room: Mapper.child<Room>(map['room']),
        records: Mapper.children<SmartScaleRecord>(map['records']),
        details: Mapper.children<SmartScaleRecord>(map['details']),
        date: map['date'],
        startDate: map['startDate'],
        executionDate: map['executionDate'],
        createdDate: map['createdDate'],
        updatedDate: map['updatedDate']);
  }
//SCALE TEAR OFF
//   @override
//   SmartScale toModelEntity(Map<String, dynamic> map) {
//     return SmartScale(
//         id: map['id'],
//         farmingCycleId: map['farmingCycleId'],
//         day: map['day'],
//         totalCount: map['totalCount'],
//         averageWeight: map['averageWeight'] != null ? map['averageWeight'].toDouble() : map['averageWeight'],
//         avgWeight: map['avgWeight'] != null ? map['avgWeight'].toDouble() : map['avgWeight'],
//         roomId: map['roomId'],
//         records: Mapper.children<SmartScaleRecord>(map['records']),
//         details: Mapper.children<SmartScaleRecord>(map['details']),
//         date: map['date'],
//         startDate: map['startDate'],
//         executionDate: map['executionDate'],
//         createdDate: map['createdDate'],
//         updatedDate: map['updatedDate']);
//   }
}
