import 'package:model/engine_library.dart';
import 'package:model/internal_app/sales_person_model.dart';

@SetupModel
class SalespersonListResponse {
    int? code;
    List<SalesPerson?> data;

    SalespersonListResponse({this.code, required this.data});

    static SalespersonListResponse toResponseModel(Map<String, dynamic> map) => SalespersonListResponse(
        code: map['code'],
        data: Mapper.children<SalesPerson>(map['data']),
    );
}