import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_projection/farm_projection_component_detail_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmProjectionComponent {

    @IsChild()
    FarmProjectionComponentDetail? current;

    @IsChild()
    FarmProjectionComponentDetail? projected;

    FarmProjectionComponent({this.current, this.projected});

    static FarmProjectionComponent toResponseModel(Map<String, dynamic> map) {
        return FarmProjectionComponent(
            current: Mapper.child<FarmProjectionComponentDetail>(map['current']),
            projected: Mapper.child<FarmProjectionComponentDetail>(map['projected'])
        );
    }
}