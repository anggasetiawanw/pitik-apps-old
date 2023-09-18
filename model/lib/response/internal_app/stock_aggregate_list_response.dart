import 'package:model/engine_library.dart';
import 'package:model/internal_app/stock_model.dart';

@SetupModel
class ListStockAggregateResponse {
    int? code;
    List<StockModel?> data;

    ListStockAggregateResponse({this.code, required this.data});

    static ListStockAggregateResponse toResponseModel(Map<String, dynamic> map) {
        return ListStockAggregateResponse(
            code: map['code'],
            data: Mapper.children<StockModel>(map['data'])
        );
    }
}