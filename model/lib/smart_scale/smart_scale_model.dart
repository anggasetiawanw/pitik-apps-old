// ignore_for_file: slash_for_doc_comments

import 'package:model/smart_scale/smart_scale_record_model.dart';

import '../engine_library.dart';
import '../room_model.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class SmartScale {

    String? id;
    int? totalCount;
    double? averageWeight;
    String? roomId;

    @IsChild()
    Room? room;

    @IsChildren()
    List<SmartScaleRecord?> records;

    String? executionDate;
    String? createdDate;
    String? updatedDate;

    SmartScale({this.id, this.totalCount, this.averageWeight, this.roomId, this.room, this.records = const [], this.executionDate, this.createdDate, this.updatedDate});

    static SmartScale toResponseModel(Map<String, dynamic> map) {
        return SmartScale(
            id: map['id'],
            totalCount: map['totalCount'],
            averageWeight: map['averageWeight'].toDouble(),
            roomId: map['roomId'],
            room: Mapper.child<Room>(map['room']),
            records: Mapper.children<SmartScaleRecord>(map['records']),
            executionDate: map['executionDate'],
            createdDate: map['createdDate'],
            updatedDate: map['updatedDate']
        );
    }
}