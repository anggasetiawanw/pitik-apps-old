// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import '../record_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class CameraListResponse {
  int code;
  int count;

  @IsChildren()
  List<RecordCamera?>? data;

  CameraListResponse({required this.code, required this.data, required this.count});

  static CameraListResponse toResponseModel(Map<String, dynamic> map) {
    return CameraListResponse(
      code: map['code'],
      count: map['count'],
      data: Mapper.children<RecordCamera>(map['data']),
    );
  }
}
