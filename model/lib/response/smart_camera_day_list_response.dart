import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/smart_camera/smart_camera_day_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class SmartCameraDayListResponse {

    @IsChildren()
    List<SmartCameraDay?> data;

    SmartCameraDayListResponse({this.data = const []});

    static SmartCameraDayListResponse toResponseModel(Map<String, dynamic> map) {
        return SmartCameraDayListResponse(
            data: Mapper.children<SmartCameraDay>(map['data'])
        );
    }
}