import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/stock_summary_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class StockSummaryResponse {

    int? code;

    @IsChild()
    StockSummary? data;

    StockSummaryResponse({this.code, this.data});

    static StockSummaryResponse toResponseModel(Map<String, dynamic> map) {
        return StockSummaryResponse(
            code: map['code'],
            data: Mapper.child<StockSummary>(map['data'])
        );
    }
}