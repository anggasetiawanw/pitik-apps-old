import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_actual/farm_actual_cycle_model.dart';
import 'package:model/farm_actual/farm_actual_detail_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmActual {

    String? date;

    @IsChild()
    FarmActualDetail? abw;

    @IsChild()
    FarmActualDetail? mortality;

    @IsChild()
    FarmActualDetail? feedConsumption;

    @IsChild()
    FarmActualCycle? cycle;

    FarmActual({this.date, this.abw, this.mortality, this.feedConsumption, this.cycle});

    static FarmActual toResponseModel(Map<String, dynamic> map) {
        return FarmActual(
            date: map['date'],
            abw: Mapper.child<FarmActualDetail>(map['abw']),
            mortality: Mapper.child<FarmActualDetail>(map['mortality']),
            feedConsumption: Mapper.child<FarmActualDetail>(map['feedConsumption']),
            cycle: Mapper.child<FarmActualCycle>(map['cycle']),
        );
    }
}