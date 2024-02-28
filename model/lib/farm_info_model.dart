import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_info_detail_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmInfo {
  @IsChild()
  FarmInfoDetail? farmingInfo;

  FarmInfo({this.farmingInfo});

  static FarmInfo toResponseModel(Map<String, dynamic> map) {
    return FarmInfo(farmingInfo: Mapper.child<FarmInfoDetail>(map['farmingInfo']));
  }
}
