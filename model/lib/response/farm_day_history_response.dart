import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/farm_day_history_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmDayHistoryResponse {
  @IsChildren()
  List<FarmDayHistory?> data;

  FarmDayHistoryResponse({this.data = const []});

  static FarmDayHistoryResponse toResponseModel(Map<String, dynamic> map) {
    return FarmDayHistoryResponse(data: Mapper.children<FarmDayHistory>(map['data']));
  }
}
