// ignore_for_file: slash_for_doc_comments

import '../device_setting_model.dart';
import 'package:model/engine_library.dart';

/// @author Robertus Mahardhi Kuncoro
/// @email <robert.kuncoro@pitik.id>
/// @create date 10/10/23

@SetupModel
class FanDetailResponse {
  int code;

  @IsChild()
  DeviceSetting? data;

  FanDetailResponse({required this.code, required this.data});

  static FanDetailResponse toResponseModel(Map<String, dynamic> map) {
    return FanDetailResponse(code: map['code'], data: Mapper.child<DeviceSetting>(map['data']));
  }
}
