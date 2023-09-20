// ignore_for_file: slash_for_doc_comments

import 'package:model/smart_scale/smart_scale_record_model.dart';

import '../engine_library.dart';
import '../room_model.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupEntity
@SetupModel
@Table("t_smart_scale")
class SmartScale extends Offline {

    @Attribute(name: "id", type: "VARCHAR", length: 100, notNull: true)
    String? id;

    @Attribute(name: "totalCount", type: "INTEGER", length: 10, defaultValue: "0")
    int? totalCount;

    @Attribute(name: "averageWeight", type: "REAL", length: 10, defaultValue: "0")
    double? averageWeight;

    @Attribute(name: "roomId", type: "VARCHAR", length: 100, notNull: true)
    String? roomId;

    @IsChild()
    Room? room;

    @Attribute(name: "records", type: "VARCHAR", length: 1000)
    @IsChildren()
    List<SmartScaleRecord?> records;

    @Attribute(name: "startDate", type: "VARCHAR", length: 100)
    String? startDate;

    @Attribute(name: "executionDate", type: "VARCHAR", length: 100)
    String? executionDate;

    @Attribute(name: "createdDate", type: "VARCHAR", length: 100)
    String? createdDate;

    @Attribute(name: "updatedDate", type: "VARCHAR", length: 100)
    String? updatedDate;

    SmartScale({this.id, this.totalCount, this.averageWeight, this.roomId, this.room, this.records = const [], this.startDate, this.executionDate, this.createdDate, this.updatedDate});

    static SmartScale toResponseModel(Map<String, dynamic> map) {
        return SmartScale(
            id: map['id'],
            totalCount: map['totalCount'],
            averageWeight: map['averageWeight'].toDouble(),
            roomId: map['roomId'],
            room: Mapper.child<Room>(map['room']),
            records: Mapper.children<SmartScaleRecord>(map['records']),
            startDate: map['startDate'],
            executionDate: map['executionDate'],
            createdDate: map['createdDate'],
            updatedDate: map['updatedDate']
        );
    }

    @override
    SmartScale toModelEntity(Map<String, dynamic> map) {
        return SmartScale(
            id: map['id'],
            totalCount: map['totalCount'],
            averageWeight: map['averageWeight'].toDouble(),
            roomId: map['roomId'],
            records: Mapper.children<SmartScaleRecord>(map['records']),
            startDate: map['startDate'],
            executionDate: map['executionDate'],
            createdDate: map['createdDate'],
            updatedDate: map['updatedDate']
        );
    }
}