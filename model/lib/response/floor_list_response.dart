import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/smart_controller/floor_list_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FloorListResponse {

    @IsChild()
    FloorList? data;

    FloorListResponse({this.data});

    static FloorListResponse toResponseModel(Map<String, dynamic> map) {
        return FloorListResponse(
            data: Mapper.child<FloorList>(map['data'])
        );
    }
}