import 'package:model/engine_library.dart';
import 'package:model/internal_app/order_categories_model.dart';

@SetupModel
class OrderIssueResponse {
    int? code;
    List<OrderIssueCategories?> data;

    OrderIssueResponse({this.code, required this.data});

    static OrderIssueResponse toResponseModel(Map<String, dynamic> map) => OrderIssueResponse(
        code: map['code'],
        data: Mapper.children<OrderIssueCategories>(map['data']),
    );
}
