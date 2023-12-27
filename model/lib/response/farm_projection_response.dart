import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_projection/farm_projection_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmProjectionResponse {

    @IsChild()
    FarmProjection? data;

    FarmProjectionResponse({this.data});

    static FarmProjectionResponse toResponseModel(Map<String, dynamic> map) {
        return FarmProjectionResponse(
            data: Mapper.child<FarmProjection>(map['data'])
        );
    }
}