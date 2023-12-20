import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_actual/farm_actual_target_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmActualDetail {

    double? actual;

    @IsChild()
    FarmActualTarget? target;

    FarmActualDetail({this.actual, this.target});

    static FarmActualDetail toResponseModel(Map<String, dynamic> map) {
        return FarmActualDetail(
            actual: map['actual'] != null ? map['actual'].toDouble() : map['actual'],
            target: Mapper.child<FarmActualTarget>(map['target'])
        );
    }
}