import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_projection/farm_projection_detail_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmProjection {
  @IsChild()
  FarmProjectionDetail? weight;

  @IsChild()
  FarmProjectionDetail? fcr;

  @IsChild()
  FarmProjectionDetail? mortality;

  FarmProjection({this.weight, this.fcr, this.mortality});

  static FarmProjection toResponseModel(Map<String, dynamic> map) {
    return FarmProjection(weight: Mapper.child<FarmProjectionDetail>(map['weight']), fcr: Mapper.child<FarmProjectionDetail>(map['fcr']), mortality: Mapper.child<FarmProjectionDetail>(map['mortality']));
  }
}
