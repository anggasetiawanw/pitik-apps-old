import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_actual/farm_actual_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmActualResponse {
  @IsChild()
  FarmActual? data;

  FarmActualResponse({this.data});

  static FarmActualResponse toResponseModel(Map<String, dynamic> map) {
    return FarmActualResponse(data: Mapper.child<FarmActual>(map['data']));
  }
}
