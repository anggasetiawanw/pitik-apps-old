// ignore_for_file: slash_for_doc_comments

import '../detail_camera_model.dart';
import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class CameraDetailResponse {
  int code;
  int count;
  DetailCamera? data;

  CameraDetailResponse({required this.code, required this.count, required this.data});

  static CameraDetailResponse toResponseModel(Map<String, dynamic> map) {
    return CameraDetailResponse(count: map['count'], code: map['code'], data: Mapper.child<DetailCamera>(map['data']));
  }
}
