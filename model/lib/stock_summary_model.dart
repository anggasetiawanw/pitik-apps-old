import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/product_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class StockSummary {

    String? date;

    @IsChildren()
    List<Product?> summaries;

    StockSummary({this.date, this.summaries = const []});

    static StockSummary toResponseModel(Map<String, dynamic> map) {
        return StockSummary(
            date: map['date'],
            summaries: Mapper.children<Product>(map['summaries'])
        );
    }
}