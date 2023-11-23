import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/harvest_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class HarvestListResponse {

    @IsChildren()
    List<Harvest?> data;

    HarvestListResponse({this.data = const []});

    static HarvestListResponse toResponseModel(Map<String, dynamic> map) {
        return HarvestListResponse(
            data: Mapper.children<Harvest>(map['data'])
        );
    }
}