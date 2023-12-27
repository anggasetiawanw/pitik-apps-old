import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_projection/farm_projection_component_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmProjectionDetail {

    FarmProjectionComponent? topGraph;

    FarmProjectionDetail({this.topGraph});

    static FarmProjectionDetail toResponseModel(Map<String, dynamic> map) {
        return FarmProjectionDetail(
            topGraph: Mapper.child<FarmProjectionComponent>(map['topGraph'])
        );
    }
}