import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/harvest_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class HarvestDetailResponse {

    @IsChild()
    Harvest? data;

    HarvestDetailResponse({this.data});

    static HarvestDetailResponse toResponseModel(Map<String, dynamic> map) {
        return HarvestDetailResponse(
            data: Mapper.child<Harvest>(map['data'])
        );
    }
}