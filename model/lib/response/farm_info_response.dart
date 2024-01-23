import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_info_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmInfoResponse {

    @IsChild()
    FarmInfo? data;

    FarmInfoResponse({this.data});

    static FarmInfoResponse toResponseModel(Map<String, dynamic> map) {
        return FarmInfoResponse(
            data: Mapper.child<FarmInfo>(map['data'])
        );
    }
}