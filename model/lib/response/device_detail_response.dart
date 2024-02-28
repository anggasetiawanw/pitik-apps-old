// ignore_for_file: slash_for_doc_comments

import '../device_model.dart';
import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class DeviceDetailResponse {
  int code;
  Device? data;

  DeviceDetailResponse({required this.code, required this.data});

  static DeviceDetailResponse toResponseModel(Map<String, dynamic> map) {
    return DeviceDetailResponse(code: map['code'], data: Mapper.child<Device>(map['data']));
  }
}
