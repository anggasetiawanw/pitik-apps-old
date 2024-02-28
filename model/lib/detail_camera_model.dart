// ignore_for_file: slash_for_doc_comments

import 'package:model/record_model.dart';

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class DetailCamera {
  String? date;
  String? buildingName;
  String? roomTypeName;

  @IsChildren()
  List<RecordCamera?>? records;

  DetailCamera({this.date, this.buildingName, this.roomTypeName, this.records});

  static DetailCamera toResponseModel(Map<String, dynamic> map) {
    return DetailCamera(
      date: map['date'],
      buildingName: map['buildingName'],
      roomTypeName: map['roomTypeName'],
      records: Mapper.children<RecordCamera>(map['records']),
    );
  }
}
