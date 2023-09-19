import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class ProductListResponse {
    int? code;
    List<Products?> data;

    ProductListResponse({this.code, required this.data});

    static ProductListResponse toResponseModel(Map<String, dynamic> map) => ProductListResponse(
        code: map['code'],
        data: Mapper.children<Products>(map['data']),
    );
}
